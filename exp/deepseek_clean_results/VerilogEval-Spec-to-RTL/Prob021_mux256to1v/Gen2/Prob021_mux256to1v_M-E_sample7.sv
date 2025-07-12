module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Intermediate wires for first level muxes
    wire [3:0] first_level [15:0];

    // First level: 16 groups of 16 inputs (64 bits per group)
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : first_level_muxes
            // Each group has 16 4-bit inputs (64 bits total)
            // Select one of 16 inputs within the group using sel[3:0]
            assign first_level[i] = in[(i*64 + sel[3:0]*4) +: 4];
        end
    endgenerate

    // Second level: Select between the 16 first-level outputs
    assign out = first_level[sel[7:4]];

endmodule