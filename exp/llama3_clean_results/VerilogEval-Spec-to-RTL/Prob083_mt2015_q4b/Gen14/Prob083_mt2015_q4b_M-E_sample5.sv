module TopModule(
    input x,
    input y,
    output z
);

// Directly assign the value of the equality check to z
assign z = (x == y);

endmodule