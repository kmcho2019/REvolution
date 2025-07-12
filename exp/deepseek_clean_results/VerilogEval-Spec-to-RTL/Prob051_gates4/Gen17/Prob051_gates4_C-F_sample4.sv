module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // All outputs computed in one clean assignment:
    assign {out_and, out_or, out_xor} = {
        &in,  // 4-input AND: 1 iff all inputs are 1
        |in,  // 4-input OR:  1 iff any input is 1
        ^in   // 4-input XOR: 1 iff odd number of 1's
    };
endmodule