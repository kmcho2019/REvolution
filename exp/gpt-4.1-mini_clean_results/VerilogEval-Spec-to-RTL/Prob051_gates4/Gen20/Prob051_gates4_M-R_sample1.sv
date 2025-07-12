module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Use continuous assignments with reduction operators
    assign out_and = &in;   // reduction AND over all 4 bits
    assign out_or  = |in;   // reduction OR over all 4 bits
    assign out_xor = ^in;   // reduction XOR over all 4 bits
endmodule