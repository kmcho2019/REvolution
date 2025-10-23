module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Intermediate 16:1 mux outputs
    wire [3:0] group_out [0:15];
    
    // First level: 16 groups of 16 inputs (16x 16:1 muxes)
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : group_muxes
            // Each group handles 16 consecutive 4-bit inputs (64 bits total)
            wire [63:0] group_in = in[i*64 +: 64];
            assign group_out[i] = group_in[sel[3:0]*4 +: 4];
        end
    endgenerate
    
    // Second level: 16:1 mux to select between groups
    assign out = group_out[sel[7:4]];
endmodule