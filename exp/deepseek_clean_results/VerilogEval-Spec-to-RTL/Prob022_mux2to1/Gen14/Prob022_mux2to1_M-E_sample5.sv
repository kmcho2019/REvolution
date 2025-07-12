module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire not_sel;
    wire and_a, and_b;
    
    // Inverter for sel signal
    not(not_sel, sel);
    
    // AND gates for input selection
    and(and_a, a, not_sel);
    and(and_b, b, sel);
    
    // OR gate to combine selected inputs
    or(out, and_a, and_b);
endmodule