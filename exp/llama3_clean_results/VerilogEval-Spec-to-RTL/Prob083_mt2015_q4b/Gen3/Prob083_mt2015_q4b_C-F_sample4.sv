module TopModule(
    input  x,
    input  y,
    output z
);

assign z = ~(x ^ y); // Using XNOR gate logic for efficiency
// Alternatively, the following line could be used for better readability, but it may synthesize differently
// assign z = (x == y);

endmodule