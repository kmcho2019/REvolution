module TopModule(
    input x,
    input y,
    output z
);

// The existing implementation is already quite efficient.
// However, for clarity and to follow best practices, we ensure that the logic is correctly implemented.
assign z = (~x & ~y) | (x & y);

endmodule