module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // 4-input AND: Outputs 1 only if all inputs are 1
    assign out_and = &in;
    
    // 4-input OR: Outputs 1 if any input is 1
    assign out_or  = |in;
    
    // 4-input XOR: Outputs 1 if odd number of inputs are 1
    assign out_xor = ^in;

endmodule