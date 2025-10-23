module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);
    // Level 1: 64 4-to-1 muxes (4x64 = 256 inputs)
    wire [63:0] stage1_out;
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : stage1_muxes
            assign stage1_out[i] = in[(i*4) + sel[1:0]];
        end
    endgenerate

    // Level 2: 16 4-to-1 muxes
    wire [15:0] stage2_out;
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage2_muxes
            assign stage2_out[i] = stage1_out[(i*4) + sel[3:2]];
        end
    endgenerate

    // Level 3: 4 4-to-1 muxes
    wire [3:0] stage3_out;
    generate
        for (i = 0; i < 4; i = i + 1) begin : stage3_muxes
            assign stage3_out[i] = stage2_out[(i*4) + sel[5:4]];
        end
    endgenerate

    // Level 4: Final 4-to-1 mux
    assign out = stage3_out[sel[7:6]];
endmodule