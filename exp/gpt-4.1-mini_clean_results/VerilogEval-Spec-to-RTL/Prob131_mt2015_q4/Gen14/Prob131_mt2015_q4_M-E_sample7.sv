// Module A: z = (x ^ y) & x
module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

// Module B: derived from waveform, z = ~(x ^ y)
module B(input x, input y, output z);
    assign z = ~(x ^ y);
endmodule

// Top-level module with different internal combinational logic combining two A and two B instances
module TopModule(input x, input y, output z);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire a_xor, b_xor;

    // Instantiate two A modules
    A A1(.x(x), .y(y), .z(a1_out));
    A A2(.x(x), .y(y), .z(a2_out));

    // Instantiate two B modules
    B B1(.x(x), .y(y), .z(b1_out));
    B B2(.x(x), .y(y), .z(b2_out));

    // XOR the outputs of the two A modules
    assign a_xor = a1_out ^ a2_out;

    // XOR the outputs of the two B modules
    assign b_xor = b1_out ^ b2_out;

    // AND the two XOR results to produce final output
    assign z = a_xor & b_xor;
endmodule