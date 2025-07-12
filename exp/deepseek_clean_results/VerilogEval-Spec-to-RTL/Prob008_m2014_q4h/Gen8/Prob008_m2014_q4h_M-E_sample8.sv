module TopModule (
    input in,
    output out
);
    // Transmission gate implementation with always-on enable
    wire enable = 1'b1;  // Hardwired enable
    
    // Transmission gate using nmos and pmos
    supply1 vdd;
    supply0 gnd;
    
    wire out_w;
    
    pmos p1(out_w, in, enable);
    nmos n1(out_w, in, enable);
    
    assign out = out_w;
endmodule