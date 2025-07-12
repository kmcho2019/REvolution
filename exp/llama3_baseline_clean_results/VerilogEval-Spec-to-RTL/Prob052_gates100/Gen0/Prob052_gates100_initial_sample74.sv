module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

assign out_and = &in; // reduction AND operation
assign out_or = |in; // reduction OR operation
assign out_xor = ^in; // reduction XOR operation

endmodule