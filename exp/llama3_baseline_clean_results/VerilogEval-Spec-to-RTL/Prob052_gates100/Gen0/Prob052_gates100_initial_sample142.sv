module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

assign out_and = &in;  // Perform 100-input AND operation
assign out_or  = |in;  // Perform 100-input OR operation
assign out_xor = ^in;  // Perform 100-input XOR operation

endmodule