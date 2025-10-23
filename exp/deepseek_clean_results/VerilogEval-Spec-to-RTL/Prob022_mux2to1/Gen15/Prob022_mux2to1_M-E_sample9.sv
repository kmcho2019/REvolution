module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);
    wire not_sel;
    wire sel_a, sel_b;
    
    // Invert sel using NAND
    nand(not_sel, sel, sel);
    
    // Selection logic
    nand(sel_a, a, not_sel);
    nand(sel_b, b, sel);
    
    // Output stage
    nand(out, sel_a, sel_b);
endmodule