module TopModule(
    input x,
    input y,
    output z
);

assign z = (x == y) ? 1'b1 : 1'b0;

// Alternatively, a more straightforward way to express this logic without using the ternary operator:
// assign z = ~(x ^ y);

endmodule