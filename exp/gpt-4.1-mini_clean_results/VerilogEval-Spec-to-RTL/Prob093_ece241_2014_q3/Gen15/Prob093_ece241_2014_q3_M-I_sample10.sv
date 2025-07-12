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
    // Helper wires for mux_in[0] (ab=00)
    // cd=00 (c=0,d=0) → 0
    // cd=01 (c=0,d=1) → 1
    // cd=11 (c=1,d=1) → 1
    // cd=10 (c=1,d=0) → 1
    wire m0_c0, m0_c1, m0;
    mux2 m0_d (.sel(d), .in0(1'b0), .in1(1'b1), .out(m0_c0)); // c=0 row: d=0->0, d=1->1
    mux2 m0_d1 (.sel(d), .in0(1'b1), .in1(1'b1), .out(m0_c1)); // c=1 row: d=0->1, d=1->1
    mux2 m0_c (.sel(c), .in0(m0_c0), .in1(m0_c1), .out(m0));

    // mux_in[1] (ab=01)
    // cd=00 (c=0,d=0) →0
    // cd=01 (c=0,d=1) →0
    // cd=11 (c=1,d=1) →0
    // cd=10 (c=1,d=0) →0
    // constant zero
    wire m1 = 1'b0;

    // mux_in[2] (ab=11)
    // cd=00 →0
    // cd=01 →0
    // cd=11 →1
    // cd=10 →0
    wire m2_c0, m2_c1, m2;
    mux2 m2_d (.sel(d), .in0(1'b0), .in1(1'b0), .out(m2_c0)); // c=0 row: d=0->0, d=1->0
    mux2 m2_d1 (.sel(d), .in0(1'b0), .in1(1'b1), .out(m2_c1)); // c=1 row: d=0->0, d=1->1
    mux2 m2_c (.sel(c), .in0(m2_c0), .in1(m2_c1), .out(m2));

    // mux_in[3] (ab=10)
    // cd=00 →1
    // cd=01 →0
    // cd=11 →1
    // cd=10 →1
    wire m3_c0, m3_c1, m3;
    mux2 m3_d (.sel(d), .in0(1'b1), .in1(1'b0), .out(m3_c0)); // c=0 row: d=0->1, d=1->0
    mux2 m3_d1 (.sel(d), .in0(1'b1), .in1(1'b1), .out(m3_c1)); // c=1 row: d=0->1, d=1->1
    mux2 m3_c (.sel(c), .in0(m3_c0), .in1(m3_c1), .out(m3));

    assign mux_in = {m3, m2, m1, m0};
endmodule