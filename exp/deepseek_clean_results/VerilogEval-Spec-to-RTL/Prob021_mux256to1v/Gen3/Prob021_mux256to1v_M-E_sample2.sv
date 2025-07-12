module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // First level: 16 groups of 16 4-bit values (64 bits per group)
    wire [63:0] group [0:15];
    
    // Split input into 16 groups
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : group_split
            assign group[i] = in[i*64 +: 64];
        end
    endgenerate

    // Second level: Select 4 bits from the selected group
    assign out = group[sel[7:4]][sel[3:0]*4 +: 4];

endmodule