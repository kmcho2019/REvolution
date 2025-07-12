module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Intermediate wires for group selections
    wire [15:0] group_selections;

    // First level: Select among 16 groups of 16 bits each
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : group_muxes
            assign group_selections[i] = in[(i*16) + sel[3:0]];
        end
    endgenerate

    // Second level: Select among the 16 group outputs
    assign out = group_selections[sel[7:4]];

endmodule