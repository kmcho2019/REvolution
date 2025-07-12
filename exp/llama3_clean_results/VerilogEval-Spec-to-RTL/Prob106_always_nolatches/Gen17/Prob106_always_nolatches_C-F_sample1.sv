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

always @(*) begin
    case (scancode)
        16'he06b: begin left = 1'b1; down = 1'b0; right = 1'b0; up = 1'b0; end
        16'he072: begin left = 1'b0; down = 1'b1; right = 1'b0; up = 1'b0; end
        16'he074: begin left = 1'b0; down = 1'b0; right = 1'b1; up = 1'b0; end
        16'he075: begin left = 1'b0; down = 1'b0; right = 1'b0; up = 1'b1; end
        default: begin left = 1'b0; down = 1'b0; right = 1'b0; up = 1'b0; end
    endcase
end

// Alternatively, using the scancode_checker module for a more modular approach
// scancode_checker left_checker(
//     .scancode(scancode),
//     .target_scancode(16'he06b),
//     .match(left)
// );

// scancode_checker down_checker(
//     .scancode(scancode),
//     .target_scancode(16'he072),
//     .match(down)
// );

// scancode_checker right_checker(
//     .scancode(scancode),
//     .target_scancode(16'he074),
//     .match(right)
// );

// scancode_checker up_checker(
//     .scancode(scancode),
//     .target_scancode(16'he075),
//     .match(up)
// );

endmodule