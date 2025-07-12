module TopModule (
    input a,
    input b,
    output out
);
    // Structural NOR implementation using transistor-like behavior
    wire out_n;
    
    // Pull-up network (acts when both inputs are low)
    pullup p1(out);
    
    // Pull-down networks (act when either input is high)
    nmos n1(out, 1'b0, a);
    nmos n2(out, 1'b0, b);
endmodule