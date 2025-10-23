module TopModule(
    input  a,
    input  b,
    output out
);
    wire not_a, not_b;
    wire and1, and2;

    // Invert inputs
    assign not_a = ~a;
    assign not_b = ~b;

    // AND gates
    assign and1 = a & b;
    assign and2 = not_a & not_b;

    // OR gate combines both AND outputs for XNOR
    assign out = and1 | and2;
endmodule