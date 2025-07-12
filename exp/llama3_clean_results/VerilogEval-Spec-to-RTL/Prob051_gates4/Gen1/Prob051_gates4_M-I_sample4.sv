module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

// Direct assignment using bitwise operators for simplicity and efficiency
assign out_and = &in;  // 4-input AND gate
assign out_or  = |in;  // 4-input OR gate
assign out_xor = ^in;  // 4-input XOR gate

endmodule