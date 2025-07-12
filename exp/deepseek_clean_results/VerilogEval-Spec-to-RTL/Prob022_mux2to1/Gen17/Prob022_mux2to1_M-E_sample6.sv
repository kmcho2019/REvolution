module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire sel_n;
    
    // Transmission gate implementation
    tranif0 tg_a(out, a, sel);  // Conducts when sel=0
    tranif1 tg_b(out, b, sel);  // Conducts when sel=1
    
    // Generate complement of sel
    not(sel_n, sel);
endmodule