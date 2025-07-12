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
    wire [7:0] stage0_out;
    wire [7:0] stage1_out;

    genvar i;

    // Stage 0: rotate by 4 bits if ctrl[2] is high
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage0_muxes
            // Select between in[i] and in[(i+4)%8]
            mux2X1 mux_stage0 (
                .d0(in[i]),
                .d1(in[(i + 4) % 8]),
                .sel(ctrl[2]),
                .y(stage0_out[i])
            );
        end
    endgenerate

    // Stage 1: rotate by 2 bits if ctrl[1] is high
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_muxes
            // Select between stage0_out[i] and stage0_out[(i+2)%8]
            mux2X1 mux_stage1 (
                .d0(stage0_out[i]),
                .d1(stage0_out[(i + 2) % 8]),
                .sel(ctrl[1]),
                .y(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: rotate by 1 bit if ctrl[0] is high
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_muxes
            // Select between stage1_out[i] and stage1_out[(i+1)%8]
            mux2X1 mux_stage2 (
                .d0(stage1_out[i]),
                .d1(stage1_out[(i + 1) % 8]),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule