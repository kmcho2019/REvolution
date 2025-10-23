module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Level 1: 8 groups of 32
    wire [7:0] level1_out;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : level1_muxes
            // Level 2: 8 groups of 4 within each 32
            wire [7:0] level2_out;
            for (genvar j = 0; j < 8; j = j + 1) begin : level2_muxes
                // Level 3: direct 4:1 mux
                wire [3:0] level3_in = in[i*32 + j*4 + 3 : i*32 + j*4];
                assign level2_out[j] = level3_in[sel[1:0]];
            end
            
            // Select among 8 level2 outputs (using sel[4:2])
            assign level1_out[i] = level2_out[sel[4:2]];
        end
    endgenerate

    // Final selection among 8 level1 outputs (using sel[7:5])
    assign out = level1_out[sel[7:5]];

endmodule