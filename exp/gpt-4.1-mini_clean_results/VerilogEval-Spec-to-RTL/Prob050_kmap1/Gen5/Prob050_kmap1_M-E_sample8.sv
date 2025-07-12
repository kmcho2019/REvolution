// 4-to-1 Multiplexer module
module Mux4to1 (
    input  s0,       // select bit 0 (LSB)
    input  s1,       // select bit 1 (MSB)
    input  d0,
    input  d1,
    input  d2,
    input  d3,
    output y
);
    wire not_s0, not_s1;
    wire and0, and1, and2, and3;

    assign not_s0 = ~s0;
    assign not_s1 = ~s1;

    assign and0 = d0 & not_s1 & not_s0;
    assign and1 = d1 & not_s1 & s0;
    assign and2 = d2 & s1 & not_s0;
    assign and3 = d3 & s1 & s0;

    assign y = and0 | and1 | and2 | and3;
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Use b and c as select lines (b is MSB, c is LSB)
    // d0 corresponds to select=00 (b=0,c=0): output = a (0 or 1)
    // d1, d2, d3 correspond to other select values and output 1
    Mux4to1 mux (
        .s0(c),
        .s1(b),
        .d0(a),
        .d1(1'b1),
        .d2(1'b1),
        .d3(1'b1),
        .y(out)
    );
endmodule