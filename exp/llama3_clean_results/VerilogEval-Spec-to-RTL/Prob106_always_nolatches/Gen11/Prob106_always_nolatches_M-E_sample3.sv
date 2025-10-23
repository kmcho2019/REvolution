module scancode_checker(
    input  [15:0] scancode,
    input  [15:0] target_scancode,
    output reg match
);

always @(*) begin
    match = (scancode == target_scancode) ? 1'b1 : 1'b0;
end

endmodule

module TopModule(
    input  [15:0] scancode,
    output left,
    output down,
    output right,
    output up
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