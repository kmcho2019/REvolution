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
    // Implement mux_in[0]: ab=00 column 0111 (cd=00..11)
    // cd=00(0),01(1),11(1),10(1)
    // Use c as select: if c=0 select d (for cd=00 or 01)
    // if c=1 select 1 (since cd=11 and 10 are 1)
    wire mux_in0_c0; // c=0: d selects 0 or 1 depending on d
    mux2 mux_in0_sel_d(.sel(d), .in0(1'b0), .in1(1'b1), .out(mux_in0_c0));
    wire mux_in0_c1 = 1'b1;
    wire mux_in0;
    mux2 mux_in0_sel_c(.sel(c), .in0(mux_in0_c0), .in1(mux_in0_c1), .out(mux_in0));

    // mux_in[1]: ab=01 column all 0
    wire mux_in1 = 1'b0;

    // mux_in[2]: ab=11 column 0010 cd=00(0),01(0),11(1),10(0)
    // Use c as select:
    // c=0 (cd=00 or 01): output 0
    // c=1 (cd=11 or 10): select d to distinguish (11=1,10=0)
    wire mux_in2_c0 = 1'b0;
    wire mux_in2_c1;
    mux2 mux_in2_sel_d(.sel(d), .in0(1'b0), .in1(1'b1), .out(mux_in2_c1));
    wire mux_in2;
    mux2 mux_in2_sel_c(.sel(c), .in0(mux_in2_c0), .in1(mux_in2_c1), .out(mux_in2));

    // mux_in[3]: ab=10 column 1001 cd=00(1),01(0),11(1),10(1)
    // Use c as select:
    // c=0 (cd=00 or 01): select d to distinguish 1 and 0
    // c=1 (cd=11 or 10): output 1 (both 11 and 10 are 1)
    wire mux_in3_c0;
    mux2 mux_in3_sel_d(.sel(d), .in0(1'b1), .in1(1'b0), .out(mux_in3_c0));
    wire mux_in3_c1 = 1'b1;
    wire mux_in3;
    mux2 mux_in3_sel_c(.sel(c), .in0(mux_in3_c0), .in1(mux_in3_c1), .out(mux_in3));

    assign mux_in = {mux_in3, mux_in2, mux_in1, mux_in0};

endmodule