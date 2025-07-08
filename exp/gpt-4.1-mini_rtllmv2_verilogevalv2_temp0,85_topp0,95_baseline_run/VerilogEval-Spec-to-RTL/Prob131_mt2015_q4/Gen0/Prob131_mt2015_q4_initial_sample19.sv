module A (
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

module B (
    input x,
    input y,
    output z
);
    // From the waveform, deduced truth table:
    // x y | z
    // 0 0 | 1
    // 0 1 | 0
    // 1 0 | 0
    // 1 1 | 1
    // Expression for z is: z = ~(x | y) + (x & y) = (~x & ~y) | (x & y)
    assign z = (~x & ~y) | (x & y);
endmodule

module top (
    input x,
    input y,
    output z
);
    wire a1_z, a2_z;
    wire b1_z, b2_z;
    wire or_out, and_out;

    // Instantiate first A and B
    A a1 (.x(x), .y(y), .z(a1_z));
    B b1 (.x(x), .y(y), .z(b1_z));
    assign or_out = a1_z | b1_z;

    // Instantiate second A and B
    A a2 (.x(x), .y(y), .z(a2_z));
    B b2 (.x(x), .y(y), .z(b2_z));
    assign and_out = a2_z & b2_z;

    // Final output
    assign z = or_out ^ and_out;
endmodule