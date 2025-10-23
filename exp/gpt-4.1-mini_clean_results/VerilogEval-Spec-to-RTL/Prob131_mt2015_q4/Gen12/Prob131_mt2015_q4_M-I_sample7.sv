// Module A: z = (x ^ y) & x
module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

// Module B: output from waveform analysis is ~(x ^ y)
module B(input x, input y, output z);
    assign z = ~(x ^ y);
endmodule

// Top-level module matching the problem specification with 2 A and 2 B instances
// First A and B outputs go to OR gate
// Second A and B outputs go to AND gate
// The outputs of OR and AND gates are XORed to produce z
module TopModule(input x, input y, output z);
    wire a_out1, b_out1;
    wire a_out2, b_out2;
    wire or_out, and_out;

    // Instantiate first pair of A and B
    A A1(.x(x), .y(y), .z(a_out1));
    B B1(.x(x), .y(y), .z(b_out1));

    // Instantiate second pair of A and B
    A A2(.x(x), .y(y), .z(a_out2));
    B B2(.x(x), .y(y), .z(b_out2));

    // OR gate with first pair outputs
    assign or_out = a_out1 | b_out1;

    // AND gate with second pair outputs
    assign and_out = a_out2 & b_out2;

    // XOR of OR and AND outputs is final output
    assign z = or_out ^ and_out;
endmodule