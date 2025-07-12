module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // 4-input AND gate output: High only if all input bits are 1
    assign out_and = &in;   

    // 4-input OR gate output: High if any input bit is 1
    assign out_or  = |in;   

    // 4-input XOR gate output: Parity of the input bits (1 if odd number of bits set)
    assign out_xor = ^in;   

endmodule