module mux2to1 (
    input sel,
    input d0,
    input d1,
    output y
);
    assign y = sel ? d1 : d0;
endmodule

module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    // Implement ~c and ~d using mux2to1 with constants
    wire not_c;
    wire not_d;
    mux2to1 inv_c (.sel(c), .d0(1'b1), .d1(1'b0), .y(not_c));
    mux2to1 inv_d (.sel(d), .d0(1'b1), .d1(1'b0), .y(not_d));

    // mux_in[0]: ab=00 column (c,d):
    // cd: 00=0, 01=1, 11=1, 10=1
    // Function: f0 = (~c & ~d)*0 + (~c & d)*1 + (c & d)*1 + (c & ~d)*1
    // Simplify f0:
    // If c=0:
    //   d=0 => 0
    //   d=1 => 1
    // If c=1:
    //   d=0 => 1
    //   d=1 => 1
    // So f0 = (~c & d) | (c) = c | (~c & d) = c | d
    // Implement c|d using muxes:
    // c|d = mux(c, d, 1)
    mux2to1 mux0 (.sel(c), .d0(d), .d1(1'b1), .y(mux_in[0]));

    // mux_in[1]: ab=01 column: all 0
    assign mux_in[1] = 1'b0;

    // mux_in[2]: ab=11 column:
    // cd: 00=0, 01=0, 11=1, 10=0
    // f2 = 1 only if c=1 and d=1
    // So f2 = c & d
    // Implement c&d:
    // mux(c, 0, d)
    mux2to1 mux2 (.sel(c), .d0(1'b0), .d1(d), .y(mux_in[2]));

    // mux_in[3]: ab=10 column:
    // cd: 00=1, 01=0, 11=1, 10=1
    // f3 true for cd=00,11,10; false only for 01
    // So f3 = (~c & ~d) | (c & d) | (c & ~d) = (~c & ~d) | c
    // f3 = c | (~c & ~d)
    // Rewrite as mux with selector c:
    // if c=0 -> output ~d
    // if c=1 -> output 1
    // Note ~d is inversion of d (already implemented)
    mux2to1 mux3 (.sel(c), .d0(not_d), .d1(1'b1), .y(mux_in[3]));

endmodule