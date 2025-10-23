// Module A: z = (x ^ y) & x
module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

// Module B: waveform-matching behavior from simulation suggests B outputs ~(x ^ y)
module B(input x, input y, output z);
    // From waveform, z is high when inputs x,y are equal, low otherwise -> z = ~(x ^ y)
    assign z = ~(x ^ y);
endmodule

// Top-level module with two A and two B instances connected as per problem description
module TopModule(input x, input y, output z);
    wire a1_out, b1_out;
    wire a2_out, b2_out;
    wire or_out, and_out;

    // Instantiate first pair of A and B modules
    A A1(.x(x), .y(y), .z(a1_out));
    B B1(.x(x), .y(y), .z(b1_out));

    // Instantiate second pair of A and B modules
    A A2(.x(x), .y(y), .z(a2_out));
    B B2(.x(x), .y(y), .z(b2_out));

    // OR gate combining first A and B outputs
    assign or_out = a1_out | b1_out;

    // AND gate combining second A and B outputs
    assign and_out = a2_out & b2_out;

    // XOR gate combining OR and AND outputs to produce z
    assign z = or_out ^ and_out;
endmodule