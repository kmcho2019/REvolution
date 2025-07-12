module TopModule(
    input x,
    input y,
    output z
);

// Refactored expression using direct logical operations
assign z = (x & y) | (~x & ~y);

endmodule