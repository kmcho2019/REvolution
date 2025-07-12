// Module A: z = (x ^ y) & x implemented with continuous assignment for combinational logic
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = ~(x ^ y) inferred from waveform, implemented as continuous assignment
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module:
// Instantiate two A and two B modules with identical inputs.
// First pair outputs go to OR gate.
// Second pair outputs go to AND gate.
// Outputs of OR and AND gates are XORed to produce final output z.
module TopModule(input wire x, input wire y, output wire z);
    wire a_out1, b_out1;
    wire a_out2, b_out2;
    wire or_out, and_out;

    // First instances of A and B
    A A1 (.x(x), .y(y), .z(a_out1));
    B B1 (.x(x), .y(y), .z(b_out1));

    // Second instances of A and B
    A A2 (.x(x), .y(y), .z(a_out2));
    B B2 (.x(x), .y(y), .z(b_out2));

    // OR gate combining first pair outputs
    assign or_out = a_out1 | b_out1;

    // AND gate combining second pair outputs
    assign and_out = a_out2 & b_out2;

    // Final XOR gate for output
    assign z = or_out ^ and_out;
endmodule