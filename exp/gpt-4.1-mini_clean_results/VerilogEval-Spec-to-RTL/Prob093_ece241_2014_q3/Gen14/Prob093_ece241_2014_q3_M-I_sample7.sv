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
    // mux_in[0] for ab=00: values at cd=00,01,11,10 → 0 0 0 1
    // For c=0: d=0->0, d=1->0
    // For c=1: d=0->1, d=1->0
    wire mux0_d;
    mux2 mux0_d_inst (.sel(d), .in0(1'b0), .in1(1'b0), .out(mux0_d));
    wire mux0;
    mux2 mux0_c_inst (.sel(c), .in0(mux0_d), .in1({1'b1,1'b0}[d]), .out(mux0));
    // Above line simplified in next lines for clarity

    // To be explicit:
    // First mux2_d: sel=d, in0=0, in1=0 → output 0
    // Second mux2_c: sel=c, in0=0, in1= (d?0:1)
    // So implement second mux2_c with d controlling inputs:
    // We'll implement second mux as: sel=c, in0=0, in1=mux0_d2
    // Where mux0_d2 = d?0:1 implemented by mux2 sel=d in0=1 in1=0

    wire mux0_d2;
    mux2 mux0_d2_inst (.sel(d), .in0(1'b1), .in1(1'b0), .out(mux0_d2));
    mux2 mux0_c2_inst (.sel(c), .in0(1'b0), .in1(mux0_d2), .out(mux0));

    // mux_in[1] for ab=01: all zeros
    wire mux1 = 1'b0;

    // mux_in[2] for ab=11: cd=00=0,01=0,11=1,10=0
    // c=0: d=0->0, d=1->0
    // c=1: d=0->0, d=1->1
    wire mux2_d;
    mux2 mux2_d_inst (.sel(d), .in0(1'b0), .in1(1'b0), .out(mux2_d));
    wire mux2_d2;
    mux2 mux2_d2_inst (.sel(d), .in0(1'b0), .in1(1'b1), .out(mux2_d2));
    wire mux2;
    mux2 mux2_c_inst (.sel(c), .in0(mux2_d), .in1(mux2_d2), .out(mux2));

    // mux_in[3] for ab=10: cd=00=1,01=0,11=1,10=1
    // c=0: d=0->1, d=1->0
    // c=1: d=0->1, d=1->1
    wire mux3_d;
    mux2 mux3_d_inst (.sel(d), .in0(1'b1), .in1(1'b0), .out(mux3_d));
    wire mux3_d2;
    mux2 mux3_d2_inst (.sel(d), .in0(1'b1), .in1(1'b1), .out(mux3_d2));
    wire mux3;
    mux2 mux3_c_inst (.sel(c), .in0(mux3_d), .in1(mux3_d2), .out(mux3));

    assign mux_in = {mux3, mux2, mux1, mux0};
endmodule