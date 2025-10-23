// Module A: z = (x XOR y) AND x
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_xy;
    assign xor_xy = x ^ y;
    assign z = xor_xy & x;
endmodule

// Module B: Output z matches waveform given inputs x and y
// From waveform, B outputs 1 if (x,y) is (0,0) or (1,1), else 0
// Thus z = ~(x ^ y)
module B (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~(x ^ y);
endmodule

// Top-level module with 2 instances each of A and B
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire a1_out, a2_out;
    wire b1_out, b2_out;

    // Instantiate first pair
    A a1 (.x(x), .y(y), .z(a1_out));
    B b1 (.x(x), .y(y), .z(b1_out));

    // Instantiate second pair
    A a2 (.x(x), .y(y), .z(a2_out));
    B b2 (.x(x), .y(y), .z(b2_out));

    // OR gate combining outputs of first A and B
    wire or_out = a1_out | b1_out;

    // AND gate combining outputs of second A and B
    wire and_out = a2_out & b2_out;

    // XOR gate combining the OR and AND results
    assign z = or_out ^ and_out;
endmodule