module TopModule(
    input x,
    input y,
    output z
);

assign z = (x == y)? 1'b1 : 1'b0;

// Alternatively, the equality can be directly assigned without the need for a ternary operator
// assign z = x == y;

endmodule