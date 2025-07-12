module TopModule(
    input x,
    input y,
    output z
);

// Explicitly defining the logic using basic gates
assign z = ~(x ^ y);

endmodule