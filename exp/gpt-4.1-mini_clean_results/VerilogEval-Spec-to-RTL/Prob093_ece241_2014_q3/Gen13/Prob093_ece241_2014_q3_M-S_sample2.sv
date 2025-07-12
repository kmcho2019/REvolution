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

    // mux_in[0] for ab=00: Output = c ? 1 : d
    wire mux_in0;
    mux2 mux_in0_d(.sel(d), .in0(1'b0), .in1(1'b1), .out(/*temp*/));
    // Actually for c=0 output = d, c=1 output=1
    // So mux2 with c selects d (in0) or 1 (in1)
    mux2 mux_in0_c(.sel(c), .in0(d), .in1(1'b1), .out(mux_in0));

    // mux_in[1] for ab=01: always 0
    wire mux_in1 = 1'b0;

    // mux_in[2] for ab=11: Output = c ? d : 0
    wire mux_in2;
    mux2 mux_in2_c(.sel(c), .in0(1'b0), .in1(d), .out(mux_in2));

    // mux_in[3] for ab=10: Output = c ? 1 : (~d)
    // since when c=0: output=1 if d=0 else 0; c=1:1
    wire not_d;
    mux2 mux_in3_d(.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));
    wire mux_in3;
    mux2 mux_in3_c(.sel(c), .in0(not_d), .in1(1'b1), .out(mux_in3));

    // Assign mux_in[3:0] corresponding to ab=00,01,11,10
    assign mux_in = {mux_in3, mux_in2, mux_in1, mux_in0};

endmodule