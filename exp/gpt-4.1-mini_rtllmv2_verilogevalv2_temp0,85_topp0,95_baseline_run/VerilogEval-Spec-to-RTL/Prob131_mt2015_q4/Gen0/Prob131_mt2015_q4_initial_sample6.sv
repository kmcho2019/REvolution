module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

module B(input x, input y, output reg z);
    // Implement B behavior as per the waveform.
    // The waveform output z depends on x and y in a way that z is 1 in some specific input cases:
    // Observing the waveform:
    // At (x,y) = (0,0), z=1
    // At (x,y) = (1,0), z=0
    // At (x,y) = (0,1), z=0
    // At (x,y) = (1,1), z=1
    // However, at some time points, even with same (x,y), output varies.
    // The waveform shows z=1 when (x,y) = (0,0), (1,1)
    // and z=0 otherwise.
    // So the logic is z = ~(x ^ y) = x == y
    // But initial waveform times show z=1 for (0,0), and 1 for (1,1)
    // So B = XNOR(x,y)
    always @(*) begin
        z = ~(x ^ y);
    end
endmodule

module top(input x, input y, output z);
    wire a1, a2, b1, b2;
    wire or_out, and_out;

    A A1(.x(x), .y(y), .z(a1));
    A A2(.x(x), .y(y), .z(a2));
    B B1(.x(x), .y(y), .z(b1));
    B B2(.x(x), .y(y), .z(b2));

    assign or_out = a1 | b1;
    assign and_out = a2 & b2;
    assign z = or_out ^ and_out;
endmodule