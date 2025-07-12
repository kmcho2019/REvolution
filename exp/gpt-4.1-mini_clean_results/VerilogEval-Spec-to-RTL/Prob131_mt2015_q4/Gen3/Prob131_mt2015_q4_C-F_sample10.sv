module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

module B(input x, input y, output z);
    // From waveform analysis, B implements XNOR(x,y)
    assign z = ~(x ^ y);
endmodule

module TopModule(input x, input y, output z);
    wire a_out, b_out;
    wire or_out, and_out;

    // Instantiate A and B once each
    A A1(.x(x), .y(y), .z(a_out));
    B B1(.x(x), .y(y), .z(b_out));

    // Use the same outputs for both OR and AND gates
    assign or_out  = a_out | b_out;
    assign and_out = a_out & b_out;

    // Final XOR to produce output
    assign z = or_out ^ and_out;
endmodule