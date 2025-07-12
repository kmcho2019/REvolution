module TopModule(
    input  a,
    input  b,
    output out
);
    
    // XNOR implementation using basic logical operators
    assign out = ~(a ^ b);

endmodule