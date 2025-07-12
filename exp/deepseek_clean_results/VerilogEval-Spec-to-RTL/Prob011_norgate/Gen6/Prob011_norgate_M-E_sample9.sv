module TopModule(
    input a,
    input b,
    output out
);
    wire out_n;
    
    // NMOS transistors pull down when either input is high
    nmos n1(out_n, 1'b0, a);
    nmos n2(out_n, 1'b0, b);
    
    // PMOS transistors pull up only when both inputs are low
    pmos p1(out_n, 1'b1, ~a);
    pmos p2(out_n, 1'b1, ~b);
    
    assign out = out_n;
endmodule