module TwoToOneMux (
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    // Stage 0: 256 inputs -> 128 outputs
    wire [127:0] stage0;
    genvar i;
    generate
        for (i = 0; i < 128; i = i + 1) begin : gen_stage0
            TwoToOneMux mux_inst (
                .in0(in[2*i]),
                .in1(in[2*i+1]),
                .sel(sel[0]),
                .out(stage0[i])
            );
        end
    endgenerate

    // Stage 1: 128 inputs -> 64 outputs
    wire [63:0] stage1;
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_stage1
            TwoToOneMux mux_inst (
                .in0(stage0[2*i]),
                .in1(stage0[2*i+1]),
                .sel(sel[1]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2: 64 inputs -> 32 outputs
    wire [31:0] stage2;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_stage2
            TwoToOneMux mux_inst (
                .in0(stage1[2*i]),
                .in1(stage1[2*i+1]),
                .sel(sel[2]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3: 32 inputs -> 16 outputs
    wire [15:0] stage3;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_stage3
            TwoToOneMux mux_inst (
                .in0(stage2[2*i]),
                .in1(stage2[2*i+1]),
                .sel(sel[3]),
                .out(stage3[i])
            );
        end
    endgenerate

    // Stage 4: 16 inputs -> 8 outputs
    wire [7:0] stage4;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_stage4
            TwoToOneMux mux_inst (
                .in0(stage3[2*i]),
                .in1(stage3[2*i+1]),
                .sel(sel[4]),
                .out(stage4[i])
            );
        end
    endgenerate

    // Stage 5: 8 inputs -> 4 outputs
    wire [3:0] stage5;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_stage5
            TwoToOneMux mux_inst (
                .in0(stage4[2*i]),
                .in1(stage4[2*i+1]),
                .sel(sel[5]),
                .out(stage5[i])
            );
        end
    endgenerate

    // Stage 6: 4 inputs -> 2 outputs
    wire [1:0] stage6;
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_stage6
            TwoToOneMux mux_inst (
                .in0(stage5[2*i]),
                .in1(stage5[2*i+1]),
                .sel(sel[6]),
                .out(stage6[i])
            );
        end
    endgenerate

    // Stage 7: 2 inputs -> 1 output
    TwoToOneMux mux_inst_final (
        .in0(stage6[0]),
        .in1(stage6[1]),
        .sel(sel[7]),
        .out(out)
    );

endmodule