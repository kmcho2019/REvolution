// Module A: z = (x XOR y) AND x, using continuous assignment
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: approximate logic from waveform; implements z = ~(x ^ y) (XNOR)
module B (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~(x ^ y);
endmodule

// Top-level module instantiating two A and two B modules
// First A and B outputs ORed, second pair ANDed, final XOR output
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire or_out, and_out;

    // Instantiate two A modules
    A a1(.x(x), .y(y), .z(a1_out));
    A a2(.x(x), .y(y), .z(a2_out));

    // Instantiate two B modules
    B b1(.x(x), .y(y), .z(b1_out));
    B b2(.x(x), .y(y), .z(b2_out));

    // OR gate: first pair outputs
    assign or_out = a1_out | b1_out;

    // AND gate: second pair outputs
    assign and_out = a2_out & b2_out;

    // XOR gate: combines or_out and and_out
    assign z = or_out ^ and_out;

endmodule