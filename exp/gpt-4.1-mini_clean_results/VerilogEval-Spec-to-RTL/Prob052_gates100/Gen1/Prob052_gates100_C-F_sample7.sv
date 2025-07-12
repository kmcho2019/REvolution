module TopModule (
    input  [99:0] in,
    output        out_and,  // Reduction AND of all 100 input bits
    output        out_or,   // Reduction OR  of all 100 input bits
    output        out_xor   // Reduction XOR of all 100 input bits
);

    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule