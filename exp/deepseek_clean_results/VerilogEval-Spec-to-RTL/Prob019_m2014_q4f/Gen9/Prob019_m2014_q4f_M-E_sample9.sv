module TopModule (
    input in1,
    input in2,
    output out
);
    wire in2_n;
    wire intermediate;
    
    // Inverter for in2
    not (in2_n, in2);
    
    // Transmission gate implementation
    tranif1 (intermediate, 1'b1, in1);  // PMOS pass when in1 is low
    tranif0 (intermediate, 1'b0, in1);  // NMOS pass when in1 is high
    tranif1 (out, intermediate, in2_n); // PMOS pass when in2_n is low
    tranif0 (out, intermediate, in2_n); // NMOS pass when in2_n is high
    
    // Weak feedback keeper
    pmos (out, 1'b1, out);  // Weak pull-up
    nmos (out, 1'b0, out);  // Weak pull-down
endmodule