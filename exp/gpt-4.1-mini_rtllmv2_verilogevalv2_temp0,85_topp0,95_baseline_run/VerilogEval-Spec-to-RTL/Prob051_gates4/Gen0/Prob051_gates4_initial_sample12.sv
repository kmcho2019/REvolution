module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

assign out_and = &in; // bitwise AND reduction
assign out_or  = |in; // bitwise OR reduction
assign out_xor = ^in; // bitwise XOR reduction

endmodule