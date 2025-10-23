module mux3to1_16bit (
    input  [15:0] in0,
    input  [15:0] in1,
    input  [15:0] in2,
    input  [1:0]  sel,
    output [15:0] out
);
    // 3-to-1 mux selecting among three 16-bit inputs using 2-bit select (only values 0-2 valid)
    assign out = (sel == 2'd0) ? in0 :
                 (sel == 2'd1) ? in1 :
                 (sel == 2'd2) ? in2 :
                 16'h0000; // default unused case - zero (won't be used in top)
endmodule

module mux3to1_16bit_sel0to2 (
    input  [15:0] in0,
    input  [15:0] in1,
    input  [15:0] in2,
    input  [1:0]  sel,
    output [15:0] out
);
    // Same as mux3to1_16bit but for clarity, separating module
    assign out = (sel == 2'd0) ? in0 :
                 (sel == 2'd1) ? in1 :
                 (sel == 2'd2) ? in2 :
                 16'h0000;
endmodule

module TopModule (
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
    wire [15:0] level1_out0, level1_out1, level1_out2;

    // First level: 3 mux3to1_16bit, each selecting among a,b,c; d,e,f; g,h,i
    mux3to1_16bit mux0 (.in0(a), .in1(b), .in2(c), .sel(sel[1:0]), .out(level1_out0));
    mux3to1_16bit mux1 (.in0(d), .in1(e), .in2(f), .sel(sel[1:0]), .out(level1_out1));
    mux3to1_16bit mux2 (.in0(g), .in1(h), .in2(i), .sel(sel[1:0]), .out(level1_out2));

    // Second level: mux3to1 selecting among the three level1 outputs
    // Use sel[3:2] for group select (0-2 valid)
    wire [15:0] level2_out;
    mux3to1_16bit_sel0to2 mux_final (
        .in0(level1_out0),
        .in1(level1_out1),
        .in2(level1_out2),
        .sel(sel[3:2]),
        .out(level2_out)
    );

    // Output logic: if sel > 8 (i.e., sel >= 9), output all ones; else output level2_out
    assign out = (sel <= 4'd8) ? level2_out : 16'hFFFF;

endmodule