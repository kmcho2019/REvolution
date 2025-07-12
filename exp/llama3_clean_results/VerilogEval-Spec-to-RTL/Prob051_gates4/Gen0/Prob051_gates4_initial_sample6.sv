module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in; // Reduction AND operator (&) applied to vector in
    assign out_or  = |in; // Reduction OR operator (|) applied to vector in
    assign out_xor = ^in; // Reduction XOR operator (^) applied to vector in

endmodule