// Module A: z = (x XOR y) AND x
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: z from waveform is ~(x XOR y), we implement accordingly
module B (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = ~(x ^ y);
endmodule

// Two-input OR gate module
module Or2 (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a | b;
endmodule

// Two-input AND gate module
module And2 (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a & b;
endmodule

// Two-input XOR gate module
module Xor2 (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a ^ b;
endmodule

// Top-level module implementing the described structure
module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    // Instantiate two A modules
    wire a1_out, a2_out;
    A a1 (.x(x), .y(y), .z(a1_out));
    A a2 (.x(x), .y(y), .z(a2_out));

    // Instantiate two B modules
    wire b1_out, b2_out;
    B b1 (.x(x), .y(y), .z(b1_out));
    B b2 (.x(x), .y(y), .z(b2_out));

    // OR gate for outputs of first A and B
    wire or_out;
    Or2 or_gate (.a(a1_out), .b(b1_out), .y(or_out));

    // AND gate for outputs of second A and B
    wire and_out;
    And2 and_gate (.a(a2_out), .b(b2_out), .y(and_out));

    // XOR gate for or_out and and_out to produce final output z
    Xor2 xor_gate (.a(or_out), .b(and_out), .y(z));

endmodule