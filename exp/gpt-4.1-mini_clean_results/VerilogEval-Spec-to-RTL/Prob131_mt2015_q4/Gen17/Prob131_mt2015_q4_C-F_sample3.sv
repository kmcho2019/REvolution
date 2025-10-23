// Module A: combinational logic z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: matches given waveform behavior: z = ~(x ^ y)
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module: instantiate two A and two B modules
// First pair outputs combined with OR, second pair outputs combined with AND
// Final output is XOR of OR and AND results
module TopModule(input wire x, input wire y, output wire z);
    wire a1_out, b1_out;
    wire a2_out, b2_out;
    wire or_out, and_out;

    // Instantiate first A and B modules
    A A1(.x(x), .y(y), .z(a1_out));
    B B1(.x(x), .y(y), .z(b1_out));

    // Instantiate second A and B modules
    A A2(.x(x), .y(y), .z(a2_out));
    B B2(.x(x), .y(y), .z(b2_out));

    // OR gate combining first A and B outputs
    assign or_out = a1_out | b1_out;

    // AND gate combining second A and B outputs
    assign and_out = a2_out & b2_out;

    // XOR gate combining OR and AND outputs to produce z
    assign z = or_out ^ and_out;
endmodule