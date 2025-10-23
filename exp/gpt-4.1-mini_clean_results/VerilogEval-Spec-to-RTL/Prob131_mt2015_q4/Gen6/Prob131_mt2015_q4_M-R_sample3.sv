// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = ~(x ^ y) (matches given waveform)
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module instantiating two A and two B modules and combining outputs as specified
module TopModule(input wire x, input wire y, output wire z);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire or_out, and_out;

    // Instantiate first pair of A and B
    A a1(.x(x), .y(y), .z(a1_out));
    B b1(.x(x), .y(y), .z(b1_out));

    // Instantiate second pair of A and B
    A a2(.x(x), .y(y), .z(a2_out));
    B b2(.x(x), .y(y), .z(b2_out));

    // Combine first pair outputs with OR gate
    assign or_out = a1_out | b1_out;

    // Combine second pair outputs with AND gate
    assign and_out = a2_out & b2_out;

    // Final output z as XOR of or_out and and_out
    assign z = or_out ^ and_out;
endmodule