module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire sel_n;
    wire out_pre;
    
    // Generate complement of sel
    not(sel_n, sel);
    
    // Transmission gate implementation
    tranif1(out_pre, a, sel_n);  // PMOS-like behavior
    tranif0(out_pre, a, sel);    // NMOS-like behavior
    tranif1(out_pre, b, sel);     // PMOS-like behavior
    tranif0(out_pre, b, sel_n);   // NMOS-like behavior
    
    // Output buffer to ensure strong drive
    buf(out, out_pre);
endmodule