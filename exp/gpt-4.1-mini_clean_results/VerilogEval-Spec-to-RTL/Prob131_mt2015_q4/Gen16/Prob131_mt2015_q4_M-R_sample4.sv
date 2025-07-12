// Module A: z = (x ^ y) & x
module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

// Module B: waveform behavior matches z = ~(x ^ y)
module B(input x, input y, output z);
    assign z = ~(x ^ y);
endmodule

// Top-level module refactored with continuous assignments combining module outputs
module TopModule(input x, input y, output z);
    wire a1_out, b1_out;
    wire a2_out, b2_out;
    wire or_out, and_out;

    // Instantiate two A modules
    A A1(.x(x), .y(y), .z(a1_out));
    A A2(.x(x), .y(y), .z(a2_out));

    // Instantiate two B modules
    B B1(.x(x), .y(y), .z(b1_out));
    B B2(.x(x), .y(y), .z(b2_out));

    // Compute OR and AND results via continuous assignment
    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;

    // XOR of OR and AND results produces final output
    assign z = or_out ^ and_out;
endmodule