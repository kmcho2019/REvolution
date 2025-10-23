module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire sel_n;
    
    // Inverted select signal for PMOS control
    assign sel_n = ~sel;
    
    // Transmission gate implementation
    tranif1 tg1 (out, a, sel_n);  // PMOS (passes '1' better)
    tranif0 tg0 (out, b, sel);    // NMOS (passes '0' better)
endmodule