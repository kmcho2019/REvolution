module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

module B(input x, input y, output z);
    // From waveform analysis:
    // z = ~(x ^ y) = XNOR(x,y)
    assign z = ~(x ^ y);
endmodule

module TopModule(input x, input y, output z);
    wire a_out1, b_out1;
    wire a_out2, b_out2;
    wire or_out, and_out;

    // First pair of submodules
    A a1(.x(x), .y(y), .z(a_out1));
    B b1(.x(x), .y(y), .z(b_out1));

    // Second pair of submodules
    A a2(.x(x), .y(y), .z(a_out2));
    B b2(.x(x), .y(y), .z(b_out2));

    // Connect outputs as specified
    assign or_out = a_out1 | b_out1;
    assign and_out = a_out2 & b_out2;

    assign z = or_out ^ and_out;
endmodule