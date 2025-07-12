module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different,
    input en_both = 1'b1,
    input en_any = 1'b1,
    input en_diff = 1'b1
);

// Shared subexpressions
wire [98:0] left_and = in[98:0] & in[99:1];
wire [98:0] left_xor = in[98:0] ^ in[99:1];
wire [98:0] right_or = in[99:1] | in[98:0];

// out_both computation
assign out_both = en_both ? {1'b0, left_and} : 100'b0;

// out_any computation
assign out_any = en_any ? {right_or, 1'b0} : 100'b0;

// out_different computation (split for timing)
wire diff_99 = en_diff ? (in[99] ^ in[0]) : 1'b0;
assign out_different = en_diff ? {diff_99, left_xor} : 100'b0;

endmodule