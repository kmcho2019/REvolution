module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

module B(input x, input y, output z);
    // Implemented as XNOR of x and y based on waveform analysis
    assign z = ~(x ^ y);
endmodule

module top(input x, input y, output z);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire or1_out, and1_out;

    A a1(.x(x), .y(y), .z(a1_out));
    B b1(.x(x), .y(y), .z(b1_out));

    A a2(.x(x), .y(y), .z(a2_out));
    B b2(.x(x), .y(y), .z(b2_out));

    assign or1_out = a1_out | b1_out;
    assign and1_out = a2_out & b2_out;

    assign z = or1_out ^ and1_out;
endmodule