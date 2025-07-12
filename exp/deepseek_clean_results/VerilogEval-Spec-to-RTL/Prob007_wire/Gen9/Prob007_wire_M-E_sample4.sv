module TopModule (
    input in,
    output out
);
    // Implement as a transmission gate
    wire out_n, out_p;
    
    // NMOS transistor (passes strong 0)
    nmos n1(out_n, in, 1'b1);
    
    // PMOS transistor (passes strong 1)
    pmos p1(out_p, in, 1'b0);
    
    // Combine the outputs
    assign out = out_n & out_p;
endmodule