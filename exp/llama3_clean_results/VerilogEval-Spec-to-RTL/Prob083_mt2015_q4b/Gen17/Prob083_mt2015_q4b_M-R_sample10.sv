// TopModule: Implements an XNOR gate
module TopModule(
    input x,  // Input signal x
    input y,  // Input signal y
    output z  // Output signal z
);
    // The XNOR gate is implemented using the efficient logical expression !(x ^ y)
    // This expression is equivalent to (x == y), ensuring z is high when x and y are the same
    assign z = !(x ^ y);
endmodule