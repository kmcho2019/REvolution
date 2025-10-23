module TopModule(
    input  [255:0] in,
    output [7:0] out
);

    // Count the number of '1's in each byte
    wire [31:0] byte_counts;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            assign byte_counts[i] = in[i*8 +: 8];
        end
    endgenerate

    // Count the number of '1's in each group of 4 bytes
    wire [7:0] group_counts;
    genvar j;
    generate
        for (j = 0; j < 8; j = j + 1) begin
            assign group_counts[j] = {1'b0, byte_counts[j*4 +: 4]} + 
                                    {1'b0, byte_counts[j*4 + 4 +: 4]} + 
                                    {1'b0, byte_counts[j*4 + 8 +: 4]} + 
                                    {1'b0, byte_counts[j*4 + 12 +: 4]};
        end
    endgenerate

    // Sum up the counts from each group of 4 bytes
    assign out = group_counts[0] + group_counts[1] + group_counts[2] + 
                 group_counts[3] + group_counts[4] + group_counts[5] + 
                 group_counts[6] + group_counts[7];

endmodule