module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

    // Implementation note:
    // The K-map rows are ordered as cd = 00,01,11,10 (Gray code),
    // so to implement functions of c,d matching this,
    // we build mux_in[x] as two-stage 2-to-1 muxes with d as first selector,
    // then c selects between groups, matching Gray code row order.

    // Helper macro to implement 2-to-1 mux
    // mux_out = sel ? in1 : in0;

    // mux_in[0] column (ab=00)
    // K-map outputs: row cd=00:0, 01:1, 11:1, 10:1
    // Stage 1: select by d:
    //   d=0: row0=0, row3=1  (rows 00 and 10)
    //   d=1: row1=1, row2=1  (rows 01 and 11)
    wire mux_in0_d0 = 1'b0; // cd=00
    wire mux_in0_d1 = 1'b1; // cd=01,11 both 1
    // Stage 2: select by c between mux_in0_d0 and mux_in0_d1
    // For Gray code row order:
    //  c=0 selects between rows 00 (d=0) and 01 (d=1)
    //  c=1 selects between rows 10 (d=0) and 11 (d=1)
    // So implement two muxes:
    wire low_c = d ? mux_in0_d1 : mux_in0_d0;  // c=0: rows 00,01
    wire high_c = d ? mux_in0_d1 : 1'b1;       // c=1: rows 11=1, 10=1

    assign mux_in[0] = c ? high_c : low_c;


    // mux_in[1] column (ab=01)
    // K-map outputs: all zeros
    assign mux_in[1] = 1'b0;


    // mux_in[2] column (ab=11)
    // K-map outputs: 00=0, 01=0, 11=1, 10=0
    // Stage 1: by d:
    // d=0 rows 00=0,10=0
    // d=1 rows 01=0,11=1
    wire mux_in2_d0 = 1'b0;
    wire mux_in2_d1 = (c == 1'b1) ? 1'b1 : 1'b0; // row11=1 if c=1 else 0

    // Stage 2: by c:
    // c=0 selects between rows 00(d=0) and 01(d=1)
    // c=1 selects between rows 10(d=0) and 11(d=1)
    wire low_c2 = d ? mux_in2_d1 : mux_in2_d0;  // c=0
    wire high_c2 = d ? mux_in2_d1 : mux_in2_d0; // c=1
    // Actually, rows 10(d=0) is 0, 11(d=1) is 1 => mux_in2_d1 and mux_in2_d0 covers it

    assign mux_in[2] = c ? high_c2 : low_c2;


    // mux_in[3] column (ab=10)
    // K-map outputs: 00=1, 01=0, 11=1, 10=1
    // Stage 1 by d:
    // d=0 rows 00=1,10=1
    // d=1 rows 01=0,11=1
    wire mux_in3_d0 = 1'b1;                   // rows 00 and 10
    wire mux_in3_d1 = (c == 1'b1) ? 1'b1 : 1'b0; // rows 11=1, 01=0

    // Stage 2 by c:
    // c=0 selects between rows 00(d=0) and 01(d=1)
    // c=1 selects between rows 10(d=0) and 11(d=1)
    wire low_c3 = d ? mux_in3_d1 : mux_in3_d0;  // c=0
    wire high_c3 = d ? mux_in3_d1 : mux_in3_d0; // c=1

    assign mux_in[3] = c ? high_c3 : low_c3;

endmodule