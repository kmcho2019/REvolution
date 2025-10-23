// Combined module AB computes outputs for both module A and B:
// A_out = (x ^ y) & x
// B_out = ~(x ^ y)
module AB(input wire x, input wire y, output wire a_out, output wire b_out);
    wire xor_xy;
    assign xor_xy = x ^ y;
    assign a_out = xor_xy & x;
    assign b_out = ~xor_xy;
endmodule

module TopModule(input wire x, input wire y, output wire z);
    wire a1, b1, a2, b2;
    wire or_out, and_out;

    // Instantiate first AB module
    AB AB1 (.x(x), .y(y), .a_out(a1), .b_out(b1));

    // Instantiate second AB module
    AB AB2 (.x(x), .y(y), .a_out(a2), .b_out(b2));

    // Perform OR of first A and B outputs
    assign or_out = a1 | b1;

    // Perform AND of second A and B outputs
    assign and_out = a2 & b2;

    // Final XOR for output
    assign z = or_out ^ and_out;
endmodule