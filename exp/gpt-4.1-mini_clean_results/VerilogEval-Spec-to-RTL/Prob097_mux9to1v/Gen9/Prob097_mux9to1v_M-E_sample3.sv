module Mux3to1_16bit(
    input  [15:0] in0,
    input  [15:0] in1,
    input  [15:0] in2,
    input  [1:0]  sel,
    output [15:0] out
);
    // 2-bit sel: 0->in0, 1->in1, 2->in2; for 3, treat as in2 (don't care for this design)
    assign out = (sel == 2'd0) ? in0 :
                 (sel == 2'd1) ? in1 :
                 (sel == 2'd2) ? in2 :
                 in2; // default to in2 if sel==3 (unused)
endmodule

module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

    wire [15:0] mux_lvl1_out [0:2];
    wire [1:0] sel_low = sel[1:0];
    wire sel_mid = sel[2];
    wire sel_high = sel[3];

    // First level: three 3-to-1 muxes selecting groups of 3 inputs each
    Mux3to1_16bit mux0 (.in0(a), .in1(b), .in2(c), .sel(sel_low), .out(mux_lvl1_out[0]));
    Mux3to1_16bit mux1 (.in0(d), .in1(e), .in2(f), .sel(sel_low), .out(mux_lvl1_out[1]));
    Mux3to1_16bit mux2 (.in0(g), .in1(h), .in2(i), .sel(sel_low), .out(mux_lvl1_out[2]));

    // Second level: a 3-to-1 mux selects one of the first level mux outputs based on sel[2]
    wire [15:0] mux_lvl2_out;
    assign mux_lvl2_out = (sel_mid == 1'b0) ? mux_lvl1_out[0] :
                          (sel_mid == 1'b1) ? mux_lvl1_out[1] :
                          mux_lvl1_out[2]; // sel_mid is 1 bit, so this case is safe

    // Detect if sel >= 9 (i.e., 4-bit sel is 1001 to 1111)
    wire invalid_sel = (sel >= 4'd9);

    assign out = invalid_sel ? 16'hFFFF : mux_lvl2_out;

endmodule