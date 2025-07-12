module TopModule(
    input x,
    input y,
    output z
);
    
    assign z = ~(x ^ y); // The XNOR operation is implemented using the XOR operator (^) and a NOT operator (~)

endmodule