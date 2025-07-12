module TopModule(
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);
    // Intermediate signals for each mux stage
    wire [255:0] stage [0:8]; 
    // stage[0] is input vector
    assign stage[0] = in;

    genvar i, j;
    // Build 8 stages of 2:1 muxes
    generate
        for (i = 0; i < 8; i = i + 1) begin : stages
            // Number of muxes in this stage is 256 >> (i+1)
            for (j = 0; j < (256 >> (i + 1)); j = j + 1) begin : muxes
                assign stage[i+1][j] = sel[i] ? stage[i][2*j+1] : stage[i][2*j];
            end
        end
    endgenerate

    // Final output is single bit after 8 stages of 2:1 muxes
    assign out = stage[8][0];

endmodule