#!/usr/bin/env python3
#
# Equalize every group of same-axis split panes in the current tab -
# stacked ("down") panes for vertical, side-by-side ("right") panes for
# horizontal - independently per branch of the layout tree. Bound to herdr
# keybindings (see config.toml) as `type = "shell"` custom commands, one per
# axis: `equalize.py vertical` / `equalize.py horizontal`.

import json
import os
import subprocess
import sys

HERDR = os.environ.get("HERDR_BIN_PATH", "herdr")

AXES = {
    "vertical": {
        "split_direction": "down",
        "grow": "down",
        "shrink": "up",
        "near_side": "top",
        "far_side": "bottom",
    },
    "horizontal": {
        "split_direction": "right",
        "grow": "right",
        "shrink": "left",
        "near_side": "left",
        "far_side": "right",
    },
}


def herdr_json(*args):
    out = subprocess.run([HERDR, *args], capture_output=True, text=True, check=True)
    return json.loads(out.stdout)


def main():
    if len(sys.argv) != 2 or sys.argv[1] not in AXES:
        sys.exit("usage: equalize.py <vertical|horizontal>")
    axis = AXES[sys.argv[1]]
    split_dir = axis["split_direction"]

    layout = herdr_json("pane", "layout")["result"]["layout"]
    panes = {p["pane_id"]: p for p in layout["panes"]}
    splits = {s["id"]: s for s in layout["splits"]}

    def rect_area(r):
        return r["width"] * r["height"]

    def find_children(split):
        d = split["direction"]
        r = split["rect"]
        candidates = [("pane", pid, p["rect"]) for pid, p in panes.items()] + [
            ("split", sid, s["rect"]) for sid, s in splits.items() if sid != split["id"]
        ]

        def contained(rc):
            return (
                rc["x"] >= r["x"]
                and rc["y"] >= r["y"]
                and rc["x"] + rc["width"] <= r["x"] + r["width"]
                and rc["y"] + rc["height"] <= r["y"] + r["height"]
            )

        if d == "down":
            first = [c for c in candidates if contained(c[2]) and c[2]["x"] == r["x"] and c[2]["y"] == r["y"] and c[2]["width"] == r["width"]]
            second = [c for c in candidates if contained(c[2]) and c[2]["x"] == r["x"] and c[2]["width"] == r["width"] and c[2]["y"] + c[2]["height"] == r["y"] + r["height"]]
        else:  # right
            first = [c for c in candidates if contained(c[2]) and c[2]["x"] == r["x"] and c[2]["y"] == r["y"] and c[2]["height"] == r["height"]]
            second = [c for c in candidates if contained(c[2]) and c[2]["y"] == r["y"] and c[2]["height"] == r["height"] and c[2]["x"] + c[2]["width"] == r["x"] + r["width"]]

        first_child = max(first, key=lambda c: rect_area(c[2]))
        second_child = max(second, key=lambda c: rect_area(c[2]))
        return (first_child[0], first_child[1]), (second_child[0], second_child[1])

    children_cache = {}

    def children(split_id):
        if split_id not in children_cache:
            children_cache[split_id] = find_children(splits[split_id])
        return children_cache[split_id]

    def unit_count(ref):
        kind, sid = ref
        if kind == "pane":
            return 1
        s = splits[sid]
        if s["direction"] != split_dir:
            return 1
        c1, c2 = children(sid)
        return unit_count(c1) + unit_count(c2)

    def edge_pane(ref, side):
        # herdr's pane-resize walks from a pane toward `direction`, targeting the
        # nearest ancestor same-axis split on the side that direction implies
        # (like pane-focus neighbor lookup). To move a specific split's ratio we
        # must hand it a pane that sits exactly on that split's edge with no
        # other same-axis split in between: descend through c1 for the near
        # edge / c2 for the far edge on same-axis splits, and try either side
        # transparently on cross-axis splits (they don't block this walk).
        kind, sid = ref
        if kind == "pane":
            return sid
        s = splits[sid]
        c1, c2 = children(sid)
        if s["direction"] == split_dir:
            return edge_pane(c1 if side == axis["near_side"] else c2, side)
        return edge_pane(c1, side) or edge_pane(c2, side)

    changes = []
    for sid, s in splits.items():
        if s["direction"] != split_dir:
            continue
        c1, c2 = children(sid)
        n1, n2 = unit_count(c1), unit_count(c2)
        if n1 + n2 == 0:
            continue
        target = n1 / (n1 + n2)
        delta = target - s["ratio"]
        if abs(delta) < 1e-4:
            continue
        if delta > 0:
            pane_id, direction = edge_pane(c1, axis["far_side"]), axis["grow"]
        else:
            pane_id, direction = edge_pane(c2, axis["near_side"]), axis["shrink"]
        changes.append((pane_id, direction, abs(delta)))

    for pane_id, direction, amount in changes:
        subprocess.run(
            [HERDR, "pane", "resize", "--direction", direction, "--amount", f"{amount:.6f}", "--pane", pane_id],
            capture_output=True, text=True, check=True,
        )

    if changes:
        print(f"equalized {len(changes)} split(s)")


if __name__ == "__main__":
    main()
