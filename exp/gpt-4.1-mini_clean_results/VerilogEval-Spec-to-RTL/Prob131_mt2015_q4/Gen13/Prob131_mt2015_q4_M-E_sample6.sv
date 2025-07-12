// Module A: z = (x XOR y) & x
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = ~((x XOR y) & x)
// To match waveform and allow flexibility, define B as complement of A logic
module B (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~((x ^ y) & x);
endmodule

// Top-level module: 
// Instantiate two A modules: A1 and A2 (same inputs x,y).
// Instantiate two B modules: B1 with inputs x,y;
// B2 with inputs modified by A1's output and y (to add input diversity).
// Combine outputs as described: 
// or_out = A1_out | B1_out
// and_out = A2_out & B2_out
// z = or_out ^ and_out
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire A1_out, A2_out;
    wire B1_out, B2_out;

    // Instantiate A1 and A2 with same inputs
    A A1 (.x(x), .y(y), .z(A1_out));
    A A2 (.x(x), .y(y), .z(A2_out));

    // Instantiate B1 with original inputs
    B B1 (.x(x), .y(y), .z(B1_out));

    // For B2, modify inputs to (A1_out, y) to add combinational diversity
    // This is a novel idea to create different input space for second B
    B B2 (
        .x(A1_out), 
        .y(y), 
        .z(B2_out)
    );

    wire or_out = A1_out | B1_out;
    wire and_out = A2_out & B2_out;

    assign z = or_out ^ and_out;
endmodule