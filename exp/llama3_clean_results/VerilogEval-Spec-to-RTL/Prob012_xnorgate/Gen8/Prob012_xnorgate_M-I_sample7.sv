module TopModule(
    input  a,
    input  b,
    output out
);
    
    // Direct XNOR implementation using basic logical operators
    assign out = (a & b) | (~a & ~b);

endmodule