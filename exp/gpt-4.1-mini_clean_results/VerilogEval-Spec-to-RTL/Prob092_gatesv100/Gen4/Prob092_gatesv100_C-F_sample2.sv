module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..98; out_both[99] = 0
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99]   = 1'b0;

    // out_any[i] = in[i] | in[i-1] for i=1..99; out_any[0] = 0
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0]    = 1'b0;

    // For out_different, rotate `in` left by 1 (wrap around) and XOR with original `in`
    wire [99:0] in_rot_left = {in[98:0], in[99]};
    assign out_different = in ^ in_rot_left;

endmodule