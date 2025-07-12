module TopModule (
    input x,
    input y,
    output z
);
    // Implements z = (x XOR y) AND x using mux implementation
    // Equivalent to: z = y ? 0 : x
    assign z = y ? 1'b0 : x;
endmodule