module TopModule (
    input in1,
    input in2,
    output out
);
    wire w1, w2, w3;
    
    // PMOS transistors (pull-up network)
    pmos p1(out, 1'b1, in1);
    pmos p2(out, w1, in2);
    pmos p3(w1, 1'b1, in1);
    
    // NMOS transistors (pull-down network)
    nmos n1(out, w2, in1);
    nmos n2(w2, 1'b0, in2);
    nmos n3(out, w3, in2);
    nmos n4(w3, 1'b0, in1);
endmodule