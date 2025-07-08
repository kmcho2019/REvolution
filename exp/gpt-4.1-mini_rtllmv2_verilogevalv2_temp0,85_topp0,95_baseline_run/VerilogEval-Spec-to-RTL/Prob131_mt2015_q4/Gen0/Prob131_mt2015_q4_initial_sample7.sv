module A(
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

module B(
    input  wire x,
    input  wire y,
    output reg  z
);
    // Implement B according to the waveform.
    // From the waveform, enumerate all x,y pairs and their outputs:
    // (0,0) -> 1
    // (1,0) -> 0
    // (0,1) -> 0
    // (1,1) -> 1
    //
    // The truth table:
    // x y | z
    // 0 0 | 1
    // 0 1 | 0
    // 1 0 | 0
    // 1 1 | 1
    //
    // This matches z = ~(x ^ y), i.e. z = ~(x xor y) = x xnor y

    always @(*) begin
        z = ~(x ^ y);
    end
endmodule

module top(
    input  wire x,
    input  wire y,
    output wire z
);
    wire a1_out, a2_out, b1_out, b2_out;
    wire or_out, and_out;

    A  a1(.x(x), .y(y), .z(a1_out));
    B  b1(.x(x), .y(y), .z(b1_out));
    A  a2(.x(x), .y(y), .z(a2_out));
    B  b2(.x(x), .y(y), .z(b2_out));

    assign or_out  = a1_out | b1_out;
    assign and_out = a2_out & b2_out;
    assign z       = or_out ^ and_out;

endmodule