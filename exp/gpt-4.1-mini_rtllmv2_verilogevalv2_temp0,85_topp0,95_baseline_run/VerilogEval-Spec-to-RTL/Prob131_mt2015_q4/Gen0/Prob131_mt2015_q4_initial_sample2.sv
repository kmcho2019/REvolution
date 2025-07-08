module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

module B(input x, input y, output reg z);
    // Implement B to produce the waveform given:
    // After examining the waveform, z is 1 for (x,y) = (0,0) and (1,1),
    // and 0 otherwise, except for some waveform time dependencies.
    // To best match the waveform, we infer:
    // z = (~x & ~y) | (x & y)
    // This matches the logic of XNOR.
    // The waveform at t=55ns (0,0) z=1 also fits.
    // So implement B as z = ~(x ^ y);
    always @(*) begin
        z = ~(x ^ y);
    end
endmodule

module top(input x, input y, output z);
    wire a1_out, a2_out, b1_out, b2_out;
    wire or_out, and_out;

    A a1(.x(x), .y(y), .z(a1_out));
    A a2(.x(x), .y(y), .z(a2_out));
    B b1(.x(x), .y(y), .z(b1_out));
    B b2(.x(x), .y(y), .z(b2_out));

    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;
    assign z = or_out ^ and_out;
endmodule