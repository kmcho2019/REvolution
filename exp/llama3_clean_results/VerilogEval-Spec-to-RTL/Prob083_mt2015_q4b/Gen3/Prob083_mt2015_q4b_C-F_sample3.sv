module TopModule(
    input  x,
    input  y,
    output z
);

// Implementing the XNOR gate logic using a simple and efficient logical expression
assign z = (x && y) || (!x &&!y);

endmodule