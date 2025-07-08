// Module A: z = (x ^ y) & x
module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

// Module B: Implemented as a combinational logic to match the waveform
// From the waveform, we can deduce truth table for inputs (x,y) -> z:
// x y | z
// 0 0 | 1
// 1 0 | 0
// 0 1 | 0
// 1 1 | 1
// This matches z = ~(x | y) | (x & y) = (x == y) (XNOR)
// So z = ~(x ^ y)

module B(input x, input y, output z);
    assign z = ~(x ^ y);
endmodule

// Top-level module as described
module top(input x, input y, output z);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire or_out, and_out;

    A a1(.x(x), .y(y), .z(a1_out));
    B b1(.x(x), .y(y), .z(b1_out));
    A a2(.x(x), .y(y), .z(a2_out));
    B b2(.x(x), .y(y), .z(b2_out));

    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;
    assign z = or_out ^ and_out;
endmodule