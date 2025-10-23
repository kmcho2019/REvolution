// Module A: Implements z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: Implements z = ~(x ^ y) (XNOR function matching waveform)
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module as per problem statement:
// - Two A submodules and two B submodules with inputs x, y
// - First pair outputs combined with OR gate
// - Second pair outputs combined with AND gate
// - Outputs of OR and AND gates combined with XOR for final output z
module TopModule(input wire x, input wire y, output wire z);
    wire a_out1, a_out2;
    wire b_out1, b_out2;
    wire or_out, and_out;

    // Instantiate first pair of submodules
    A a1(.x(x), .y(y), .z(a_out1));
    B b1(.x(x), .y(y), .z(b_out1));

    // Instantiate second pair of submodules
    A a2(.x(x), .y(y), .z(a_out2));
    B b2(.x(x), .y(y), .z(b_out2));

    // OR gate for first pair outputs
    assign or_out = a_out1 | b_out1;

    // AND gate for second pair outputs
    assign and_out = a_out2 & b_out2;

    // XOR gate for combining OR and AND outputs as final output
    assign z = or_out ^ and_out;
endmodule