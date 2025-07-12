module mux2X1 (
    input  wire d0,
    input  wire d1,
    input  wire sel,
    output wire y
);
    assign y = sel ? d1 : d0;
endmodule


module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage1, stage2;

    genvar i;

    // Stage 1: rotate right by 4 if ctrl[2] is 1, else pass through
    // To rotate right by 4: concatenate in with itself (16 bits), select bits [11:4]
    wire [15:0] in_concat = {in, in};
    wire [7:0] rotated4;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_rot4
            assign rotated4[i] = in_concat[i + 8 - 4];  // i+4 from left end since rotating right by 4
        end
    endgenerate

    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_mux4
            mux2X1 mux4_inst (
                .d0(in[i]),
                .d1(rotated4[i]),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: rotate right by 2 if ctrl[1] is 1, else pass through
    wire [15:0] stage1_concat = {stage1, stage1};
    wire [7:0] rotated2;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_rot2
            assign rotated2[i] = stage1_concat[i + 8 - 2];
        end
    endgenerate

    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_mux2
            mux2X1 mux2_inst (
                .d0(stage1[i]),
                .d1(rotated2[i]),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: rotate right by 1 if ctrl[0] is 1, else pass through
    wire [15:0] stage2_concat = {stage2, stage2};
    wire [7:0] rotated1;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_rot1
            assign rotated1[i] = stage2_concat[i + 8 - 1];
        end
    endgenerate

    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_mux1
            mux2X1 mux1_inst (
                .d0(stage2[i]),
                .d1(rotated1[i]),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule