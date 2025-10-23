module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
    wire a_out;
    wire b_out;
    wire or_out;
    wire and_out;

    // Instantiate one A and one B module
    A u_A(.x(x), .y(y), .z(a_out));
    B u_B(.x(x), .y(y), .z(b_out));

    // Compute OR and AND outputs separately
    assign or_out = a_out | b_out;
    assign and_out = a_out & b_out;

    // Final output is XOR of OR and AND results
    assign z = or_out ^ and_out;
endmodule