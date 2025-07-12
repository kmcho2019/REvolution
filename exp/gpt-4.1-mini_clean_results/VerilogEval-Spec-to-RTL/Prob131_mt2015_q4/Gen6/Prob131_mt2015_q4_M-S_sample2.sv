module TopModule(input x, input y, output z);
    wire a_out, b_out;
    wire or_out, and_out;

    // Inline logic of A: z = (x ^ y) & x
    assign a_out = (x ^ y) & x;

    // Inline logic of B: z = ~(x ^ y) (XNOR)
    assign b_out = ~(x ^ y);

    // OR and AND using the same signals
    assign or_out = a_out | b_out;
    assign and_out = a_out & b_out;

    // Final XOR output
    assign z = or_out ^ and_out;
endmodule