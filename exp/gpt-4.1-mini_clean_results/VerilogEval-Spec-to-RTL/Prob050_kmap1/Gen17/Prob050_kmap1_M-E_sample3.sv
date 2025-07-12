module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire na, nb, nc;
    wire zero_condition;

    // Invert inputs
    assign na = ~a;
    assign nb = ~b;
    assign nc = ~c;

    // Detect if all inputs are zero simultaneously
    assign zero_condition = na & nb & nc;

    // Output is negation of zero_condition (out=1 except when all zero)
    assign out = ~zero_condition;

endmodule