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

    A a(.x(x), .y(y), .z(a_out));
    B b(.x(x), .y(y), .z(b_out));

    // First pair OR: both inputs tied to the outputs of a and b
    assign or_out = a_out | b_out;

    // Second pair AND: both inputs tied to the outputs of a and b
    assign and_out = a_out & b_out;

    assign z = or_out ^ and_out;
endmodule