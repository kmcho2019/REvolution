module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

module B(input x, input y, output z);
    // Based on waveform analysis: z = XNOR(x,y)
    assign z = ~(x ^ y);
endmodule

module TopModule(input x, input y, output z);
    wire a_out, b_out;
    wire or_out, and_out;

    // Instantiate A and B once each
    A a(.x(x), .y(y), .z(a_out));
    B b(.x(x), .y(y), .z(b_out));

    // Use the same outputs as inputs for both OR and AND logic
    assign or_out  = a_out | b_out;
    assign and_out = a_out & b_out;

    // Final XOR combination
    assign z = or_out ^ and_out;
endmodule