// Module A: combinational logic z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: matches given waveform behavior: z = ~(x ^ y)
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module: instantiate two A and two B modules separately,
// then combine outputs with explicit intermediate wires and assign statements
module TopModule(input wire x, input wire y, output wire z);
    wire a1_out, b1_out;
    wire a2_out, b2_out;
    wire or_out, and_out;

    // Instantiate first pair of modules
    A a1(.x(x), .y(y), .z(a1_out));
    B b1(.x(x), .y(y), .z(b1_out));

    // Instantiate second pair of modules
    A a2(.x(x), .y(y), .z(a2_out));
    B b2(.x(x), .y(y), .z(b2_out));

    // OR gate combining first pair outputs
    assign or_out = a1_out | b1_out;

    // AND gate combining second pair outputs
    assign and_out = a2_out & b2_out;

    // XOR gate combining OR and AND outputs to produce final z
    assign z = or_out ^ and_out;
endmodule