module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // 100-input AND: Output is 1 only if all inputs are 1
    assign out_and = &in;
    
    // 100-input OR: Output is 1 if any input is 1
    assign out_or = |in;
    
    // 100-input XOR: Output is 1 if odd number of inputs are 1
    assign out_xor = ^in;

endmodule