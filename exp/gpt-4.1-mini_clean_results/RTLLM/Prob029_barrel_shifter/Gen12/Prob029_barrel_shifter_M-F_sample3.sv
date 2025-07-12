// 2-to-1 mux module: selects between inputs d0 and d1 based on sel
module mux2X1 (
    input  wire d0,
    input  wire d1,
    input  wire sel,
    output wire out
);
    assign out = sel ? d1 : d0;
endmodule

module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage0_out;
    wire [7:0] stage1_out;

    genvar i;

    // Stage 0: shift/rotate by 4 bits if ctrl[2] is high
    // For each bit i:
    // mux selects between in[i] (no shift) and in[(i+4)%8] (shift by 4)
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage0_muxes
            mux2X1 u_mux (
                .d0(in[i]),
                .d1(in[(i+4)%8]),
                .sel(ctrl[2]),
                .out(stage0_out[i])
            );
        end
    endgenerate

    // Stage 1: shift/rotate by 2 bits if ctrl[1] is high
    // mux selects between stage0_out[i] and stage0_out[(i+2)%8]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_muxes
            mux2X1 u_mux (
                .d0(stage0_out[i]),
                .d1(stage0_out[(i+2)%8]),
                .sel(ctrl[1]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: shift/rotate by 1 bit if ctrl[0] is high
    // mux selects between stage1_out[i] and stage1_out[(i+1)%8]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_muxes
            mux2X1 u_mux (
                .d0(stage1_out[i]),
                .d1(stage1_out[(i+1)%8]),
                .sel(ctrl[0]),
                .out(out[i])
            );
        end
    endgenerate

endmodule