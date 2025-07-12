module TopModule (
    input a,
    input b,
    output out
);
    wire not_a, not_b;
    wire and1, and2;

    // Invert inputs
    assign not_a = ~a;
    assign not_b = ~b;

    // AND gates for (a AND b) and (NOT a AND NOT b)
    assign and1 = a & b;
    assign and2 = not_a & not_b;

    // OR gate combines the two AND outputs to form XNOR
    assign out = and1 | and2;
endmodule