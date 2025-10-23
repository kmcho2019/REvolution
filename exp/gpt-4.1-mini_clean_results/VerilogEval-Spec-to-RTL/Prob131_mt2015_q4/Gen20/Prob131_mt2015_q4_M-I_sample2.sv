// Module A: z = (x XOR y) AND x
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_xy = x ^ y;
    assign z = xor_xy & x;
endmodule

// Top-level optimized module
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire a_out;                // output of A
    wire b_out;                // output of B equivalent (inverter of x ^ y)
    wire or_out;
    wire and_out;

    // Instantiate A module
    A a_inst (
        .x(x),
        .y(y),
        .z(a_out)
    );

    // B module replaced by direct assign (b_out = ~(x ^ y))
    assign b_out = ~(x ^ y);

    // OR gate of first pair (A and B outputs)
    assign or_out = a_out | b_out;

    // AND gate of second pair (A and B outputs)
    assign and_out = a_out & b_out;

    // XOR of OR and AND gates for final output z
    assign z = or_out ^ and_out;

endmodule