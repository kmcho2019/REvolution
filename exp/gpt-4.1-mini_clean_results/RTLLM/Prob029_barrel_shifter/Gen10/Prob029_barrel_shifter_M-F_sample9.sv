module mux2X1_bs (
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

    // Stage 0: shift by 1 bit if ctrl[0] = 1
    generate
        for (i=0; i<8; i=i+1) begin : stage0
            // rotated left by 1: source bit is (i+1)&7
            mux2X1_bs mux_inst (
                .d0(in[i]),
                .d1(in[(i+1)&3'b111]),
                .sel(ctrl[0]),
                .y(stage0_out[i])
            );
        end
    endgenerate

    // Stage 1: shift by 2 bits if ctrl[1] = 1
    generate
        for (i=0; i<8; i=i+1) begin : stage1
            // rotated left by 2: source bit is (i+2)&7
            mux2X1_bs mux_inst (
                .d0(stage0_out[i]),
                .d1(stage0_out[(i+2)&3'b111]),
                .sel(ctrl[1]),
                .y(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: shift by 4 bits if ctrl[2] = 1
    generate
        for (i=0; i<8; i=i+1) begin : stage2
            // rotated left by 4: source bit is (i+4)&7
            mux2X1_bs mux_inst (
                .d0(stage1_out[i]),
                .d1(stage1_out[(i+4)&3'b111]),
                .sel(ctrl[2]),
                .y(out[i])
            );
        end
    endgenerate

endmodule