module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // First level: 16 16-to-1 muxes (packed array)
    wire [63:0] first_level;  // 16x4 bits
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : first_level_muxes
            assign first_level[i*4 +: 4] = in[(i*64 + sel[3:0]*4) +: 4];
        end
    endgenerate

    // Combined second and third level: direct 16-to-1 mux
    assign out = first_level[(sel[7:4]*4) +: 4];

endmodule