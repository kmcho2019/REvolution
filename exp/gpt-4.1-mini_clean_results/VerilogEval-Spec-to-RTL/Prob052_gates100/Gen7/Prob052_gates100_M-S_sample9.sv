module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // Direct reduction operators over entire 100-bit input vector
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;
endmodule