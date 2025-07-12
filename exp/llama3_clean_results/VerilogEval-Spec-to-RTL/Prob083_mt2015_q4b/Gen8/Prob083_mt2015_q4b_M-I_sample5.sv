module TopModule(
    input x,
    input y,
    output z
);

// Assign z directly with the simplified expression !(x ^ y)
assign z = !(x ^ y);

endmodule