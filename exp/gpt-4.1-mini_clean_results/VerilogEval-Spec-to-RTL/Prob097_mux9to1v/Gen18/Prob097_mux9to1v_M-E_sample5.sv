module mux3to1 (
    input  [15:0] in0,
    input  [15:0] in1,
    input  [15:0] in2,
    input  [1:0]  sel,
    output [15:0] out
);
    // 3-to-1 mux based on sel (2 bits)
    assign out = (sel == 2'd0) ? in0 :
                 (sel == 2'd1) ? in1 :
                 (sel == 2'd2) ? in2 :
                 16'hFFFF; // default to all ones for safety, though sel only 0-2 here
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

    wire [15:0] group0_out;
    wire [15:0] group1_out;
    wire [15:0] group2_out;

    // Lower 2 bits select inside groups
    wire [1:0] lower_sel = sel[1:0];
    // Upper bits select among groups
    wire [1:0] upper_sel = sel[3:2];

    // Group 0: a, b, c (indices 0,1,2)
    mux3to1 mux_group0 (
        .in0(a),
        .in1(b),
        .in2(c),
        .sel(lower_sel),
        .out(group0_out)
    );

    // Group 1: d, e, f (indices 3,4,5)
    mux3to1 mux_group1 (
        .in0(d),
        .in1(e),
        .in2(f),
        .sel(lower_sel),
        .out(group1_out)
    );

    // Group 2: g, h, i (indices 6,7,8)
    mux3to1 mux_group2 (
        .in0(g),
        .in1(h),
        .in2(i),
        .sel(lower_sel),
        .out(group2_out)
    );

    // Final mux selects one of the three group outputs based on upper_sel.
    // If sel >= 9 (sel = 4'b1001) up to 4'b1111, output all ones.
    assign out = (sel <= 4'd8) ? (
                    (upper_sel == 2'd0) ? group0_out :
                    (upper_sel == 2'd1) ? group1_out :
                    (upper_sel == 2'd2) ? group2_out :
                    16'hFFFF
                 ) : 16'hFFFF;

endmodule