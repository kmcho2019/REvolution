module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Create a hierarchy of intermediate selection wires
    wire [0:255] mux_level [0:7];  // 8 levels (log2(256))
    
    // Level 0: Direct inputs
    assign mux_level[0] = in;
    
    // Generate selection tree
    genvar level, idx;
    generate
        for (level = 1; level <= 7; level = level + 1) begin : gen_levels
            for (idx = 0; idx < (256 >> level); idx = idx + 1) begin : gen_muxes
                assign mux_level[level][idx] = sel[7-level] ? 
                    mux_level[level-1][2*idx+1] : 
                    mux_level[level-1][2*idx];
            end
        end
    endgenerate
    
    // Final output
    assign out = mux_level[7][0];

endmodule