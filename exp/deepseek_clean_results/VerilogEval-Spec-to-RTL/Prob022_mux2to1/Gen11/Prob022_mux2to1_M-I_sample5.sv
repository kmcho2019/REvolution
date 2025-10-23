module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Transmission gate implementation
    wire sel_n;
    
    assign sel_n = ~sel;
    
    // Transmission gates
    tranif1 tg1(a, out, sel_n);  // PMOS (active when sel=0)
    tranif0 tg2(b, out, sel);    // NMOS (active when sel=1)
endmodule