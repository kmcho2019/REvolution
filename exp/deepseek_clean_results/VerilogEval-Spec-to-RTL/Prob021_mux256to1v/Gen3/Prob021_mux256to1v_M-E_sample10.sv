module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Parameterized binary tree implementation
    genvar bit, level;
    generate
        for (bit = 0; bit < 4; bit = bit + 1) begin : bit_slices
            // Create 256 inputs for this bit position
            wire [255:0] level0;
            for (genvar i = 0; i < 256; i = i + 1) begin : input_assign
                assign level0[i] = in[i*4 + bit];
            end

            // Binary tree reduction
            wire [255:0] tree [0:7];
            assign tree[0] = level0;
            
            for (level = 0; level < 7; level = level + 1) begin : tree_levels
                for (genvar j = 0; j < (128 >> level); j = j + 1) begin : muxes
                    assign tree[level+1][j] = sel[level] ? 
                                           tree[level][2*j+1] : 
                                           tree[level][2*j];
                end
            end
            
            assign out[bit] = tree[7][0];
        end
    endgenerate

endmodule