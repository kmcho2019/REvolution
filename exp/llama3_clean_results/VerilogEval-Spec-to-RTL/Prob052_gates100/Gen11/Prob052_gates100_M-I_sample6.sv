module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in; // Using reduction operator for AND
    assign out_or  = |in;  // Using reduction operator for OR
    assign out_xor = ^in;  // Using reduction operator for XOR

endmodule