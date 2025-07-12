// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: inferred from waveform as XNOR function
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Simplified top-level module:
// Use only one instance of A and one instance of B,
// reuse their outputs for both the OR and AND gates,
// then XOR the OR and AND results for the final output.
module TopModule(input wire x, input wire y, output wire z);
    wire a_out, b_out;

    // Single instance of A and B each
    A a_inst(.x(x), .y(y), .z(a_out));
    B b_inst(.x(x), .y(y), .z(b_out));

    // OR and AND with the same a_out and b_out
    wire or_out = a_out | b_out;
    wire and_out = a_out & b_out;

    // Final XOR output
    assign z = or_out ^ and_out;
endmodule