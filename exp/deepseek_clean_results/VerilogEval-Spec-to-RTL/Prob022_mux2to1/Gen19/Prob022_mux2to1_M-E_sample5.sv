module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire not_sel;
    wire and_a;
    wire and_b;

    // Invert the select signal
    not inv1(not_sel, sel);

    // AND gates for the two paths
    and and1(and_a, not_sel, a);
    and and2(and_b, sel, b);

    // OR gate to combine the paths
    or or1(out, and_a, and_b);
endmodule