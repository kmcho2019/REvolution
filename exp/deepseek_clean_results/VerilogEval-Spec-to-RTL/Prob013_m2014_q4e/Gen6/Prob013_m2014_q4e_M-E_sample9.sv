module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Transmission gate implementation of NOR
    wire w1, w2;
    
    // PMOS transistors (active low)
    pmos p1(w1, 1'b1, in1);    // Pull-up when in1 is low
    pmos p2(w1, 1'b1, in2);    // Pull-up when in2 is low
    
    // NMOS transistors (active high)
    nmos n1(w1, 1'b0, in1);    // Pull-down when in1 is high
    nmos n2(w1, 1'b0, in2);    // Pull-down when in2 is high
    
    // Output buffer to ensure strong drive
    bufif1 b1(out, 1'b1, w1);  // Output is high when w1 is high
    
    // Alternative representation showing the NOR truth table explicitly
    // This is just for documentation, not part of the actual implementation
    /*
    Truth Table:
    in1 in2 | out
    ------------
     0   0  |  1
     0   1  |  0
     1   0  |  0
     1   1  |  0
    */
endmodule