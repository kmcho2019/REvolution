module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire not_sel;
    wire and_a, and_b;
    
    // Invert select signal
    not inv1(not_sel, sel);
    
    // AND gates for selection paths
    and and1(and_a, a, not_sel);
    and and2(and_b, b, sel);
    
    // Final OR gate
    or or1(out, and_a, and_b);
endmodule