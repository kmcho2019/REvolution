module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Create 8 levels of 4-bit wide 2-to-1 multiplexers
    wire [3:0] mux_level [0:7][0:255]; // [level][mux_index]
    
    // Level 0: Inputs
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : input_level
            assign mux_level[0][i] = in[i*4 +: 4];
        end
    endgenerate
    
    // Subsequent levels
    genvar level, mux;
    generate
        for (level = 1; level < 8; level = level + 1) begin : mux_levels
            for (mux = 0; mux < (256 >> level); mux = mux + 1) begin : mux_instances
                assign mux_level[level][mux] = sel[level-1] ? 
                    mux_level[level-1][mux*2 + 1] : 
                    mux_level[level-1][mux*2];
            end
        end
    endgenerate
    
    // Final output
    assign out = mux_level[7][0];
endmodule