module mux2to1 (
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // For ab=00 (mux_in[0]):
    // cd: 00->0, 01->1, 11->1, 10->1
    // Let's implement as: 
    // Level 1: mux d selects between 0 and 1
    // Level 2: mux c selects between result of level 1 and 1
    // Specifically:
    // when c=0, output = d (0 or 1)
    // when c=1, output = 1
    wire mux0_l1;
    mux2to1 mux0_d (.sel(d), .in0(1'b0), .in1(1'b1), .out(mux0_l1));
    mux2to1 mux0_c (.sel(c), .in0(mux0_l1), .in1(1'b1), .out(mux_in[0]));

    // For ab=01 (mux_in[1]):
    // All zeros
    assign mux_in[1] = 1'b0;

    // For ab=11 (mux_in[2]):
    // cd: 00->0, 01->0, 11->1, 10->0
    // Implement as:
    // when c=0, output=0
    // when c=1, output=d
    mux2to1 mux2_c (.sel(c), .in0(1'b0), .in1(d), .out(mux_in[2]));

    // For ab=10 (mux_in[3]):
    // cd: 00->1, 01->0, 11->1, 10->1
    // Cannot use ~d, implement inversion by mux:
    // Let's implement inversion of d by mux_invert_d:
    wire invert_d;
    mux2to1 invert_d_mux (.sel(d), .in0(1'b1), .in1(1'b0), .out(invert_d));

    // Now implement:
    // when c=0 output = invert_d
    // when c=1 output = 1
    mux2to1 mux3_c (.sel(c), .in0(invert_d), .in1(1'b1), .out(mux_in[3]));

endmodule