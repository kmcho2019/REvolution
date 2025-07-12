// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: output matches simulation waveform, i.e., XNOR function
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module instantiates two "logical" instances each of A and B,
// but shares the outputs since inputs are identical, preserving functionality
module TopModule(input wire x, input wire y, output wire z);
    wire a_out, b_out;
    wire or_out, and_out;

    // Single physical instance of A and B modules
    A a_inst(.x(x), .y(y), .z(a_out));
    B b_inst(.x(x), .y(y), .z(b_out));

    // Use same outputs for both OR and AND gates to represent two pairs of instances
    // OR gate: output of first A instance OR output of first B instance
    assign or_out = a_out | b_out;

    // AND gate: output of second A instance AND output of second B instance
    assign and_out = a_out & b_out;

    // Final XOR combines OR and AND outputs
    assign z = or_out ^ and_out;
endmodule