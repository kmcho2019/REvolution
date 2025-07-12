module mux2 (
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

    // ab=00: cd=00:0,01:1,11:1,10:1
    // For c=0: output = d
    // For c=1: output = 1
    wire ab00_c0;
    mux2 m0_d(.sel(d), .in0(1'b0), .in1(1'b1), .out(ab00_c0));
    wire ab00;
    mux2 m0_c(.sel(c), .in0(ab00_c0), .in1(1'b1), .out(ab00));

    // ab=01: always 0
    wire ab01 = 1'b0;

    // ab=11: cd=00:0,01:0,11:1,10:0
    // For c=0: 0
    // For c=1: d
    wire ab11_c1;
    mux2 m2_d(.sel(d), .in0(1'b0), .in1(1'b1), .out(ab11_c1));
    wire ab11;
    mux2 m2_c(.sel(c), .in0(1'b0), .in1(ab11_c1), .out(ab11));

    // ab=10: cd=00:1,01:0,11:1,10:1
    // For c=0: ~d
    // For c=1: 1
    wire ab10_c0;
    mux2 m3_d(.sel(d), .in0(1'b1), .in1(1'b0), .out(ab10_c0));
    wire ab10;
    mux2 m3_c(.sel(c), .in0(ab10_c0), .in1(1'b1), .out(ab10));

    // Arrange mux_in as {ab=10, ab=11, ab=01, ab=00}
    assign mux_in = {ab10, ab11, ab01, ab00};

endmodule