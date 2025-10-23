module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // First stage: Select among 16 groups using upper 4 bits of sel
    wire [63:0] group [0:15];
    
    // Split input into 16 groups of 64 bits (16 4-bit inputs)
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : group_split
            assign group[i] = in[i*64 +: 64];
        end
    endgenerate
    
    // Second stage: Select within the chosen group using lower 4 bits
    assign out = group[sel[7:4]][sel[3:0]*4 +: 4];
endmodule