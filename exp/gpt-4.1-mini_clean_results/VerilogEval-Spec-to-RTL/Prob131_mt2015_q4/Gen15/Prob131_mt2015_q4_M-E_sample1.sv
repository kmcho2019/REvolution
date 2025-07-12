// Combined module computing both A and B outputs:
// A_out = (x ^ y) & x
// B_out = ~(x ^ y)
module AB(input wire x, input wire y, output wire a_out, output wire b_out);
    wire xor_xy;
    assign xor_xy = x ^ y;
    assign a_out = xor_xy & x;
    assign b_out = ~xor_xy;
endmodule

// Top module instantiating two AB modules and combining outputs as specified
module TopModule(input wire x, input wire y, output wire z);
    wire a1, b1, a2, b2;
    wire or_out, and_out;

    // First AB instance
    AB AB1(.x(x), .y(y), .a_out(a1), .b_out(b1));
    assign or_out = a1 | b1;

    // Second AB instance
    AB AB2(.x(x), .y(y), .a_out(a2), .b_out(b2));
    assign and_out = a2 & b2;

    // Final XOR output
    assign z = or_out ^ and_out;
endmodule