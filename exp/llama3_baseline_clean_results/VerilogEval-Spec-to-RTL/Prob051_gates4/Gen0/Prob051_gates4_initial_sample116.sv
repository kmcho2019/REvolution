module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

assign out_and = &in; // 4-input AND operation
assign out_or = |in;  // 4-input OR operation
assign out_xor = ^in; // 4-input XOR operation

endmodule