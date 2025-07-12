module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // All outputs computed using reduction operators:
    // - AND: true when all bits are 1
    // - OR:  true when any bit is 1
    // - XOR: true when odd number of bits are 1
    assign out_and = &in;  // 4-input AND
    assign out_or  = |in;  // 4-input OR
    assign out_xor = ^in;  // 4-input XOR

endmodule