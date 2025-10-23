module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Borrow generate and propagate
    wire [3:0] g = (~A) & B;
    wire [3:0] p = ~(A ^ B);

    // Borrow out logic simplified directly without intermediate wires
    wire borrow_out = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

    // Bitwise equality signals (XNOR)
    wire [3:0] bit_equal = ~(A ^ B);

    // Single 4-input AND gate for equality detection
    wire equal_bits = &bit_equal;

    // Outputs are mutually exclusive
    assign A_less    = borrow_out;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_out | equal_bits);

endmodule