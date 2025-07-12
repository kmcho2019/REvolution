module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Level 1: 256 inputs -> 64 4:1 muxes
    wire [63:0] level1_out;
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : level1_muxes
            assign level1_out[i] = in[(i*4) + sel[1:0]];
        end
    endgenerate

    // Level 2: 64 inputs -> 16 4:1 muxes
    wire [15:0] level2_out;
    generate
        for (i = 0; i < 16; i = i + 1) begin : level2_muxes
            assign level2_out[i] = level1_out[(i*4) + sel[3:2]];
        end
    endgenerate

    // Level 3: 16 inputs -> 4 4:1 muxes
    wire [3:0] level3_out;
    generate
        for (i = 0; i < 4; i = i + 1) begin : level3_muxes
            assign level3_out[i] = level2_out[(i*4) + sel[5:4]];
        end
    endgenerate

    // Final level: 4 inputs -> 1 4:1 mux
    assign out = level3_out[sel[7:6]];

endmodule