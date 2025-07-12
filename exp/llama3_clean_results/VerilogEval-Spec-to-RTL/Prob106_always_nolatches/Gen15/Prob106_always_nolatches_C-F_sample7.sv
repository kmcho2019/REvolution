module scancode_map(
    input  [15:0] scancode,
    input  [15:0] target_scancode,
    output reg match
);

reg [3:0] lut [4:0]; // targeted LUT for arrow key scancodes

initial begin
    lut[0] = 16'he06b; // left arrow
    lut[1] = 16'he072; // down arrow
    lut[2] = 16'he074; // right arrow
    lut[3] = 16'he075; // up arrow
end

always @(*) begin
    match = 1'b0;
    for (int i = 0; i < 4; i++) begin
        if (scancode == lut[i]) begin
            match = 1'b1;
        end
    end
end

endmodule

module TopModule(
    input  [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

scancode_map left_map(
    .scancode(scancode),
    .target_scancode(16'he06b),
    .match(left)
);

scancode_map down_map(
    .scancode(scancode),
    .target_scancode(16'he072),
    .match(down)
);

scancode_map right_map(
    .scancode(scancode),
    .target_scancode(16'he074),
    .match(right)
);

scancode_map up_map(
    .scancode(scancode),
    .target_scancode(16'he075),
    .match(up)
);

endmodule