// Module A: z = (x ^ y) & x, continuous assignment
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: output z is XNOR of x and y
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top module with only one instance each of A and B modules.
// Outputs of these instances are shared for the two pairs before OR and AND.
module TopModule(input wire x, input wire y, output wire z);
    wire a_out, b_out;
    wire or_out, and_out;

    // Single instances of modules A and B
    A a_inst(.x(x), .y(y), .z(a_out));
    B b_inst(.x(x), .y(y), .z(b_out));

    // First pair: OR of outputs
    assign or_out = a_out | b_out;

    // Second pair: AND of outputs (same shared signals used to simulate second pair)
    assign and_out = a_out & b_out;

    // Final XOR output
    assign z = or_out ^ and_out;
endmodule