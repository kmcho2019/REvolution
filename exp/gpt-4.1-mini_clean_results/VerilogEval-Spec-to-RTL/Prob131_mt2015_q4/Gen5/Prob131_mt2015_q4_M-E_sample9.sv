// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: matches waveform, z = ~(x ^ y)
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module with two instances of A and B each
module TopModule(input wire x, input wire y, output wire z);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire or_out, and_out;

    // First instance of A
    A a1(.x(x), .y(y), .z(a1_out));

    // First instance of B
    B b1(.x(x), .y(y), .z(b1_out));

    // OR gate combining outputs of first A and B
    assign or_out = a1_out | b1_out;

    // Second instance of A
    A a2(.x(x), .y(y), .z(a2_out));

    // Second instance of B
    B b2(.x(x), .y(y), .z(b2_out));

    // AND gate combining outputs of second A and B
    assign and_out = a2_out & b2_out;

    // XOR final output of OR and AND gates
    assign z = or_out ^ and_out;
endmodule