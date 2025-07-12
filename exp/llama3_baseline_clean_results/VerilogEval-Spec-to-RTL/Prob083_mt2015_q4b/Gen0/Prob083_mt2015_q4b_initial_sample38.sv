module TopModule(
    input  x,
    input  y,
    output z
);

assign z = ~(x ^ y); // Using the XOR (^) operator and then inverting the result to achieve XNOR functionality

endmodule