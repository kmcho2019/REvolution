// Module A: combinational logic z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: matches given waveform behavior: z = ~(x ^ y)
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module: instantiate one A and one B modules,
// reuse their outputs for both pairs to reduce duplication
module TopModule(input wire x, input wire y, output wire z);
    wire a_out, b_out;
    wire or_out, and_out;

    // Single instances of A and B modules
    A a_inst(.x(x), .y(y), .z(a_out));
    B b_inst(.x(x), .y(y), .z(b_out));

    // First pair output: OR of A and B outputs
    assign or_out = a_out | b_out;

    // Second pair output: AND of same A and B outputs
    assign and_out = a_out & b_out;

    // Final output: XOR of the two pair results
    assign z = or_out ^ and_out;
endmodule