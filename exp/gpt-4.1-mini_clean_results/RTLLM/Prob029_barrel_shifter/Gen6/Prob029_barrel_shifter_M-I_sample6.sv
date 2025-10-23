// 2-to-1 MUX module: selects between d0 and d1 based on sel
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
    // Stage 1: rotate right by 4 if ctrl[2] == 1
    wire [7:0] stage1;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_muxes
            // Rotate right by 4 means bit i is connected to in[(i + 4) % 8]
            mux2X1 mux_stage1 (
                .d0(in[i]),
                .d1(in[(i + 4) % 8]),
                .sel(ctrl[2]),
                .y(stage1[i])
            );
        end
    endgenerate

    // Stage 2: rotate right by 2 if ctrl[1] == 1
    wire [7:0] stage2;

    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_muxes
            // Rotate right by 2 means bit i is connected to stage1[(i + 2) % 8]
            mux2X1 mux_stage2 (
                .d0(stage1[i]),
                .d1(stage1[(i + 2) % 8]),
                .sel(ctrl[1]),
                .y(stage2[i])
            );
        end
    endgenerate

    // Stage 3: rotate right by 1 if ctrl[0] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_muxes
            // Rotate right by 1 means bit i is connected to stage2[(i + 1) % 8]
            mux2X1 mux_stage3 (
                .d0(stage2[i]),
                .d1(stage2[(i + 1) % 8]),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule