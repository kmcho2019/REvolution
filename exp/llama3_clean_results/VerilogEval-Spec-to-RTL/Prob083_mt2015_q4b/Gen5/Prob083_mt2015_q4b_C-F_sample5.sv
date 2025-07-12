module TopModule(
    input  x,
    input  y,
    output z
);

// Implementing the XNOR gate logic using a simplified and efficient expression
assign z = (x == y);

endmodule