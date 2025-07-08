module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

module B(input x, input y, output reg z);
    // Model the waveform behavior in combinational logic:
    // Based on analysis of the waveform:
    // z = ~(x | y) | (x & y)
    // Equivalent to: z = (~x & ~y) | (x & y)
    always @(*) begin
        if ((x == 0 && y == 0) || (x == 1 && y == 1))
            z = 1;
        else
            z = 0;
    end
endmodule

module top(input x, input y, output z);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire or_out, and_out;

    // Instantiate two A modules
    A a1(.x(x), .y(y), .z(a1_out));
    A a2(.x(x), .y(y), .z(a2_out));

    // Instantiate two B modules
    B b1(.x(x), .y(y), .z(b1_out));
    B b2(.x(x), .y(y), .z(b2_out));

    // OR gate for first A and B outputs
    assign or_out = a1_out | b1_out;

    // AND gate for second A and B outputs
    assign and_out = a2_out & b2_out;

    // XOR gate for OR and AND outputs to produce z
    assign z = or_out ^ and_out;
endmodule