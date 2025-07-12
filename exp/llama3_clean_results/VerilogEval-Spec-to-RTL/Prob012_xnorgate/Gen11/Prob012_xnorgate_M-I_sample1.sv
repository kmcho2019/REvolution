module TopModule(
    input  a,
    input  b,
    output out
);
    
    // XNOR implementation using the equality operator
    assign out = ~(a ^ b);

endmodule