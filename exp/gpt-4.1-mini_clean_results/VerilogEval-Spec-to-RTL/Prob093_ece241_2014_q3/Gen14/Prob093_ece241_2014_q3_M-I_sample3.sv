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

    // ab=00 -> mux_in[0]: f = c + d = mux2(sel=c, in0=d, in1=1)
    wire mux_in0;
    mux2 mux_in0_inst(.sel(c), .in0(d), .in1(1'b1), .out(mux_in0));

    // ab=01 -> mux_in[1]: always 0
    wire mux_in1 = 1'b0;

    // ab=11 -> mux_in[2]: c & d = mux2(sel=c, in0=0, in1=d)
    wire mux_in2;
    mux2 mux_in2_inst(.sel(c), .in0(1'b0), .in1(d), .out(mux_in2));

    // ab=10 -> mux_in[3]: c + ~d
    wire not_d;
    mux2 not_d_inst(.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));
    wire mux_in3;
    mux2 mux_in3_inst(.sel(c), .in0(not_d), .in1(1'b1), .out(mux_in3));

    // Assign mux_in = {ab=10, ab=11, ab=01, ab=00}
    assign mux_in = {mux_in3, mux_in2, mux_in1, mux_in0};

endmodule