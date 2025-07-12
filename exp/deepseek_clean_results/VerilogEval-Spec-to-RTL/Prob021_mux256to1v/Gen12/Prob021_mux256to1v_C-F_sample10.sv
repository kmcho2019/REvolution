module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Optimized hierarchical approach with direct selection
    wire [3:0] group_out [15:0];
    
    generate
        for (genvar i = 0; i < 16; i = i + 1) begin : group_muxes
            // Each group handles 16 4-bit inputs (64 bits)
            // Direct selection within group using sel[3:0]
            assign group_out[i] = in[(i*64 + sel[3:0]*4) +: 4];
        end
    endgenerate

    // Final selection between groups using sel[7:4]
    assign out = group_out[sel[7:4]];

endmodule