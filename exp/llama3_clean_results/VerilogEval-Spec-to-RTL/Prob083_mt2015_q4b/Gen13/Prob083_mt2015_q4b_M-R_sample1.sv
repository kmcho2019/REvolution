module TopModule(
    input x,
    input y,
    output z
);

// Refactored logic using equality comparison and inversion
assign z = !(x != y);

endmodule