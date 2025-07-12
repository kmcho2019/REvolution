module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

// Implementing the TopModule as a 4-input XOR gate using 2-input XOR gates
assign q = a ^ b ^ c ^ d;

endmodule