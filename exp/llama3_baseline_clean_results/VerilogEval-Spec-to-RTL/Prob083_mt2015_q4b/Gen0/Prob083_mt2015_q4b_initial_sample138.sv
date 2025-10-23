module TopModule(
    input x,
    input y,
    output z
);

assign z = (x == y) ? 1'b1 : 1'b0;

// Alternatively, this can also be implemented using the XNOR operator (^~) 
// assign z = ~(x ^ y);

endmodule