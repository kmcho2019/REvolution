module scancode_checker(
    input  wire [15:0] scancode,
    input  wire [15:0] target_scancode,
    output wire         match
);

assign match = (scancode == target_scancode) ? 1'b1 : 1'b0;

endmodule

module TopModule(
    input  wire [15:0] scancode,
    output wire         left,
    output wire         down,
    output wire         right,
    output wire         up
);

scancode_checker left_checker(
    .scancode(scancode),
    .target_scancode(16'he06b),
    .match(left)
);

scancode_checker down_checker(
    .scancode(scancode),
    .target_scancode(16'he072),
    .match(down)
);

scancode_checker right_checker(
    .scancode(scancode),
    .target_scancode(16'he074),
    .match(right)
);

scancode_checker up_checker(
    .scancode(scancode),
    .target_scancode(16'he075),
    .match(up)
);

endmodule