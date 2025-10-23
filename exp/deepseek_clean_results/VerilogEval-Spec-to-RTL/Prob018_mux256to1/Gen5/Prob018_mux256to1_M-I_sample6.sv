module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // First level: 16 groups of 16 inputs each
    wire [15:0] mux_level1 [15:0];
    
    // Generate 16x16:1 muxes
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : level1_muxes
            assign mux_level1[i] = in[(i*16)+15 +: 16];
        end
    endgenerate
    
    // Second level: 16:1 mux to select from first level outputs
    assign out = mux_level1[sel[7:4]][sel[3:0]];

endmodule