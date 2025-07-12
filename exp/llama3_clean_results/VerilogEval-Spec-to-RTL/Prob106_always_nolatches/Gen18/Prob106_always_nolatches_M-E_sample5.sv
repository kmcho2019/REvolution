module ScancodeDetector(
    input  [15:0] scancode,
    input  [15:0] target_scancode,
    output reg match
);

assign match = (scancode == target_scancode);

endmodule

module TopModule(
    input  [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

ScancodeDetector left_detector(
   .scancode(scancode),
   .target_scancode(16'he06b),
   .match(left)
);

ScancodeDetector down_detector(
   .scancode(scancode),
   .target_scancode(16'he072),
   .match(down)
);

ScancodeDetector right_detector(
   .scancode(scancode),
   .target_scancode(16'he074),
   .match(right)
);

ScancodeDetector up_detector(
   .scancode(scancode),
   .target_scancode(16'he075),
   .match(up)
);

endmodule