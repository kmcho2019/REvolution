module TopModule (
    input in1,
    input in2,
    output out
);
    wire intermediate;
    
    // PMOS pull-up network (active low)
    pmos p1(intermediate, 1'b1, in1);
    pmos p2(intermediate, 1'b1, in2);
    
    // NMOS pull-down network (active high)
    nmos n1(intermediate, 1'b0, in1);
    nmos n2(intermediate, 1'b0, in2);
    
    // Keeper inverter to maintain state when both inputs are 0
    not (out, intermediate);
endmodule