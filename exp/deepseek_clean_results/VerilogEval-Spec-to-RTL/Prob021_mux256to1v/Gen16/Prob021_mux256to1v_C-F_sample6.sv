module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // First stage: 16 groups of 16 4-bit inputs
    wire [63:0] group [0:15];
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : group_split
            // Only assign the relevant 4-bit slice when selected
            assign group[i] = in[i*64 + sel[3:0]*4 +: 4];
        end
    endgenerate

    // Second stage: Final selection from chosen group
    assign out = group[sel[7:4]];

endmodule