module TopModule (
    input in,
    output out
);
    // Implement using transmission gate with always-on control
    supply1 vdd;
    supply0 gnd;
    
    tranif1 nmos(out, in, vdd);  // NMOS with gate always high
    tranif0 pmos(out, in, gnd);   // PMOS with gate always low
endmodule