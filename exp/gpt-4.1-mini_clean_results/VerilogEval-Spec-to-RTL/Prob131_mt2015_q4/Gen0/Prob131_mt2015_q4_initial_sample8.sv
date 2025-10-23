// Module A: z = (x ^ y) & x
module A (
    input wire x,
    input wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: modeled to replicate the given waveform behavior combinationally
// From the waveform:
// z=1 at (x,y) = (0,0) and (1,1) at several times; also (0,0) mostly z=1.
// (0,1) and (1,0) mostly output 0 except some 0,1 with 0.
// To match this, we will implement z = ~(x ^ y) with some bias for (0,0) always 1.
// Because waveform always shows z=1 at (0,0), and z=1 at (1,1) at some times, let's simplify to:
// z = ~(x ^ y), i.e., z = XNOR(x,y)
module B (
    input wire x,
    input wire y,
    output wire z
);
    assign z = ~(x ^ y);
endmodule

// Top module as described
module top (
    input wire x,
    input wire y,
    output wire z
);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire or_out, and_out;

    // Instantiate first A and B
    A a1(.x(x), .y(y), .z(a1_out));
    B b1(.x(x), .y(y), .z(b1_out));

    // Instantiate second A and B
    A a2(.x(x), .y(y), .z(a2_out));
    B b2(.x(x), .y(y), .z(b2_out));

    // OR gate: a1_out OR b1_out
    assign or_out = a1_out | b1_out;

    // AND gate: a2_out AND b2_out
    assign and_out = a2_out & b2_out;

    // XOR gate: or_out XOR and_out -> z
    assign z = or_out ^ and_out;

endmodule