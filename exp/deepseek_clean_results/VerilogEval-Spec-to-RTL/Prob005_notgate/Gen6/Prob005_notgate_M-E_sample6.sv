module TopModule (
    input in,
    output out
);
    // Transmission gate implementation of NOT
    wire in_n;
    assign in_n = ~in;  // Internal inversion
    
    // Transmission gate acts as a buffer for in_n
    // When in=1, PMOS is off and NMOS passes 0
    // When in=0, NMOS is off and PMOS passes 1
    tranif1(out, in_n, in);    // NMOS
    tranif0(out, in_n, in);    // PMOS
endmodule