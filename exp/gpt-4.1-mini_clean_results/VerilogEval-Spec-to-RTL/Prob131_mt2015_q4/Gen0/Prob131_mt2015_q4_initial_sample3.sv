`timescale 1ns / 1ps

// Module A: z = (x ^ y) & x
module A (
    input wire x,
    input wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: Implemented based on given waveform.
// Let's analyze the waveform for B outputs:

// Inputs and output z:
// time x y z
//  0ns   0  0  1
// 25ns   1  0  0
// 35ns   0  1  0
// 45ns   1  1  1
// 55ns   0  0  1
// 60ns   0  1  0
// 70ns   1  1  1
// 90ns   1  0  0

// Summary of output z:
// x y | z
// 0 0 | 1
// 1 0 | 0
// 0 1 | 0
// 1 1 | 1

// This truth table matches z = ~(x ^ y) or z = ~(x xor y) = x XNOR y

// Implement B as x XNOR y

module B (
    input wire x,
    input wire y,
    output wire z
);
    assign z = ~(x ^ y);
endmodule

// Top-level module
module top_module (
    input wire x,
    input wire y,
    output wire z
);
    // Instantiate two A modules
    wire a1_out, a2_out;
    A A1(.x(x), .y(y), .z(a1_out));
    A A2(.x(x), .y(y), .z(a2_out));

    // Instantiate two B modules
    wire b1_out, b2_out;
    B B1(.x(x), .y(y), .z(b1_out));
    B B2(.x(x), .y(y), .z(b2_out));

    // Connect outputs: OR gate for first pair (a1_out, b1_out)
    wire or_out = a1_out | b1_out;

    // AND gate for second pair (a2_out, b2_out)
    wire and_out = a2_out & b2_out;

    // XOR the OR and AND outputs to produce final z
    assign z = or_out ^ and_out;

endmodule