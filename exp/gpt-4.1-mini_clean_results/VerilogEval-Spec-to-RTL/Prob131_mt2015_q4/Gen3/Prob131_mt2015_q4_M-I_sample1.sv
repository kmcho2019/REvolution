module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

module B(input x, input y, output z);
    // From waveform analysis:
    // z = ~(x ^ y) = XNOR(x,y)
    assign z = ~(x ^ y);
endmodule

module TopModule(input x, input y, output z);
    wire a_out, b_out;

    A a_inst(.x(x), .y(y), .z(a_out));
    B b_inst(.x(x), .y(y), .z(b_out));

    // Simplified top-level logic: z = a_out ^ b_out
    assign z = a_out ^ b_out;
endmodule