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
    // For each mux_in bit, implement function of c and d using two mux2 in cascade:
    // output = mux2(sel=c, in0= f_c0, in1= f_c1)
    // where f_c0 = mux2(sel=d, in0=val_c0d0, in1=val_c0d1)
    //       f_c1 = mux2(sel=d, in0=val_c1d0, in1=val_c1d1)

    // Mapping from Karnaugh map:
    // ab=00 → mux_in[0]
    //   cd=00 (c=0,d=0) → 0
    //   cd=01 (c=0,d=1) → 0
    //   cd=11 (c=1,d=1) → 0
    //   cd=10 (c=1,d=0) → 1
    wire f0_c0, f0_c1, mux0;
    // c=0 row: d=0->0, d=1->0
    mux2 m0_0 (.sel(d), .in0(1'b0), .in1(1'b0), .out(f0_c0));
    // c=1 row: d=0->1, d=1->0
    mux2 m0_1 (.sel(d), .in0(1'b1), .in1(1'b0), .out(f0_c1));
    mux2 m0_c (.sel(c), .in0(f0_c0), .in1(f0_c1), .out(mux0));

    // ab=01 → mux_in[1]
    // All zeros
    wire mux1 = 1'b0;

    // ab=11 → mux_in[2]
    // cd=00 (c=0,d=0) → 0
    // cd=01 (c=0,d=1) → 0
    // cd=11 (c=1,d=1) → 1
    // cd=10 (c=1,d=0) → 0
    wire f2_c0, f2_c1, mux2_out;
    // c=0 row: d=0->0, d=1->0
    mux2 m2_0 (.sel(d), .in0(1'b0), .in1(1'b0), .out(f2_c0));
    // c=1 row: d=0->0, d=1->1
    mux2 m2_1 (.sel(d), .in0(1'b0), .in1(1'b1), .out(f2_c1));
    mux2 m2_c (.sel(c), .in0(f2_c0), .in1(f2_c1), .out(mux2_out));

    // ab=10 → mux_in[3]
    // cd=00 (c=0,d=0) → 1
    // cd=01 (c=0,d=1) → 0
    // cd=11 (c=1,d=1) → 1
    // cd=10 (c=1,d=0) → 1
    wire f3_c0, f3_c1, mux3_out;
    // c=0 row: d=0->1, d=1->0
    mux2 m3_0 (.sel(d), .in0(1'b1), .in1(1'b0), .out(f3_c0));
    // c=1 row: d=0->1, d=1->1
    mux2 m3_1 (.sel(d), .in0(1'b1), .in1(1'b1), .out(f3_c1));
    mux2 m3_c (.sel(c), .in0(f3_c0), .in1(f3_c1), .out(mux3_out));

    assign mux_in = {mux3_out, mux2_out, mux1, mux0};
endmodule