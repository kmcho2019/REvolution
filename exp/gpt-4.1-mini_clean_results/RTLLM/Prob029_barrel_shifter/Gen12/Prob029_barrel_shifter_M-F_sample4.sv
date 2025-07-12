module mux2X1_bs (
    input  wire d0,
    input  wire d1,
    input  wire sel,
    output wire y
);
    // 2-to-1 multiplexer: y = sel ? d1 : d0
    assign y = sel ? d1 : d0;
endmodule

module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    wire [7:0] stage4_out;  // Output after 4-bit shift stage
    wire [7:0] stage2_out;  // Output after 2-bit shift stage

    genvar i;

    // Stage 4-bit left rotate if ctrl[2] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage4
            // Rotated bit position: (i + 4) mod 8
            mux2X1_bs mux_inst (
                .d0(in[i]),
                .d1(in[(i + 4) & 3'b111]),
                .sel(ctrl[2]),
                .y(stage4_out[i])
            );
        end
    endgenerate

    // Stage 2-bit left rotate if ctrl[1] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2
            // Rotated bit position: (i + 2) mod 8
            mux2X1_bs mux_inst (
                .d0(stage4_out[i]),
                .d1(stage4_out[(i + 2) & 3'b111]),
                .sel(ctrl[1]),
                .y(stage2_out[i])
            );
        end
    endgenerate

    // Stage 1-bit left rotate if ctrl[0] == 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1
            // Rotated bit position: (i + 1) mod 8
            mux2X1_bs mux_inst (
                .d0(stage2_out[i]),
                .d1(stage2_out[(i + 1) & 3'b111]),
                .sel(ctrl[0]),
                .y(out[i])
            );
        end
    endgenerate

endmodule