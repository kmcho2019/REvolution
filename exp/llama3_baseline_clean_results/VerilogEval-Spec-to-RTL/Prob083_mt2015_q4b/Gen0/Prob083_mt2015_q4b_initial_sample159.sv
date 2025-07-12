module TopModule(
    input x,
    input y,
    output z
);

assign z = (x == y)? 1'b1 : 1'b0;

// Alternatively, you can also express it as
// assign z = ~(x ^ y);

endmodule