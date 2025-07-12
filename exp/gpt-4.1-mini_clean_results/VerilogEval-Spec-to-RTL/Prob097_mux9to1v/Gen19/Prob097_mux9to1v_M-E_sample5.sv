module mux3to1_16b (
    input  [15:0] in0,
    input  [15:0] in1,
    input  [15:0] in2,
    input  [1:0]  sel,
    output reg [15:0] out
);
    always @(*) begin
        case (sel)
            2'd0: out = in0;
            2'd1: out = in1;
            2'd2: out = in2;
            default: out = 16'hFFFF; // Defensive default, not expected
        endcase
    end
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

    // Stage 1: Three 3-to-1 muxes for input groups
    wire [15:0] stage1_out0;
    wire [15:0] stage1_out1;
    wire [15:0] stage1_out2;

    // Lower 2 bits select inside groups
    wire [1:0] lower_sel = sel[1:0];

    mux3to1_16b mux_stage1_0 (
        .in0(a),
        .in1(b),
        .in2(c),
        .sel(lower_sel),
        .out(stage1_out0)
    );

    mux3to1_16b mux_stage1_1 (
        .in0(d),
        .in1(e),
        .in2(f),
        .sel(lower_sel),
        .out(stage1_out1)
    );

    mux3to1_16b mux_stage1_2 (
        .in0(g),
        .in1(h),
        .in2(i),
        .sel(lower_sel),
        .out(stage1_out2)
    );

    // Stage 2: select among three stage1 outputs
    wire [15:0] stage2_out;
    mux3to1_16b mux_stage2 (
        .in0(stage1_out0),
        .in1(stage1_out1),
        .in2(stage1_out2),
        .sel(sel[3:2]),
        .out(stage2_out)
    );

    // Stage 3: Final output selection or default 16'hFFFF
    assign out = (sel <= 4'd8) ? stage2_out : 16'hFFFF;

endmodule