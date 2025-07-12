module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

module B(input x, input y, output z);
    // B implements XNOR(x,y) per waveform analysis
    assign z = ~(x ^ y);
endmodule

module TopModule(input x, input y, output z);
    wire a_out, b_out;
    wire or_out, and_out;

    // Instantiate A and B once each
    A a(.x(x), .y(y), .z(a_out));
    B b(.x(x), .y(y), .z(b_out));

    // Use the single outputs of A and B as inputs for both OR and AND gates
    assign or_out = a_out | b_out;
    assign and_out = a_out & b_out;

    // XOR the results for final output
    assign z = or_out ^ and_out;
endmodule