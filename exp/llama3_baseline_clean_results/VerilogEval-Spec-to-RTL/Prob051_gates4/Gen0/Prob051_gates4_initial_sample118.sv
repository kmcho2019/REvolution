module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;  // reduction AND
    assign out_or  = |in;  // reduction OR
    assign out_xor = ^in;  // reduction XOR

endmodule