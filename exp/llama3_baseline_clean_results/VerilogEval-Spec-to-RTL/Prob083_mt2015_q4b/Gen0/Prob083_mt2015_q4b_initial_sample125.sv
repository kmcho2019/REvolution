module TopModule(
    input  x,
    input  y,
    output z
);
    
    assign z = ~(x ^ y); // The XNOR operation is implemented using XOR (^) and inverting the result

endmodule