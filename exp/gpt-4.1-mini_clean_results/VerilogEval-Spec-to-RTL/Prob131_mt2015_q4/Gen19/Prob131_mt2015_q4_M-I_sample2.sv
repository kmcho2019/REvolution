// Module A: z = (x XOR y) AND x
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
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

// Optimized Top-level module: instantiate A and B only once each
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire a_out, b_out;

    // Instantiate modules once each
    A a_inst (.x(x), .y(y), .z(a_out));
    B b_inst (.x(x), .y(y), .z(b_out));

    // First pair output: OR of A and B
    wire or_out = a_out | b_out;

    // Second pair output: AND of A and B (same inputs, so same outputs used)
    wire and_out = a_out & b_out;

    // Final XOR gate
    assign z = or_out ^ and_out;
endmodule