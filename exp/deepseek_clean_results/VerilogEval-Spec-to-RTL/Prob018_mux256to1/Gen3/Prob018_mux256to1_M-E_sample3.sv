module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

// Binary tree of 2-to-1 muxes
wire [255:0] level [0:7];
assign level[0] = in;

genvar lvl, idx;
generate
    for (lvl = 0; lvl < 7; lvl = lvl + 1) begin : tree_level
        for (idx = 0; idx < (1 << (7-lvl)); idx = idx + 1) begin : muxes
            assign level[lvl+1][idx] = sel[lvl] ? 
                                      level[lvl][2*idx+1] : 
                                      level[lvl][2*idx];
        end
    end
endgenerate

assign out = level[7][0];

endmodule