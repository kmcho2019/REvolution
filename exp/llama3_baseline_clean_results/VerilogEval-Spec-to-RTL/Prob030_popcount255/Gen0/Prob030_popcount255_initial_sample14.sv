module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Count the number of '1's in each byte (8 bits)
    wire [7:0] byte_counts [31:0];
    genvar i;
    generate
        for (i = 0; i < 32; i++) begin: count_bytes
            assign byte_counts[i] = {8{1'b0}} + 
                in[8*i+7:8*i];
        end
    endgenerate

    // Count the number of '1's in each group of 32 bytes (256 bits, ignoring last 1 bit)
    wire [5:0] group_counts [7:0];
    generate
        for (i = 0; i < 8; i++) begin: count_groups
            assign group_counts[i] = {6{1'b0}} + 
                byte_counts[32*i+31:32*i] + 
                byte_counts[32*i+30:32*i+1] + 
                byte_counts[32*i+29:32*i+2] + 
                byte_counts[32*i+28:32*i+3] + 
                byte_counts[32*i+27:32*i+4] + 
                byte_counts[32*i+26:32*i+5] + 
                byte_counts[32*i+25:32*i+6] + 
                byte_counts[32*i+24:32*i+7] + 
                byte_counts[32*i+23:32*i+8] + 
                byte_counts[32*i+22:32*i+9] + 
                byte_counts[32*i+21:32*i+10] + 
                byte_counts[32*i+20:32*i+11] + 
                byte_counts[32*i+19:32*i+12] + 
                byte_counts[32*i+18:32*i+13] + 
                byte_counts[32*i+17:32*i+14] + 
                byte_counts[32*i+16:32*i+15] + 
                byte_counts[32*i+15:32*i+16] + 
                byte_counts[32*i+14:32*i+17] + 
                byte_counts[32*i+13:32*i+18] + 
                byte_counts[32*i+12:32*i+19] + 
                byte_counts[32*i+11:32*i+20] + 
                byte_counts[32*i+10:32*i+21] + 
                byte_counts[32*i+9:32*i+22] + 
                byte_counts[32*i+8:32*i+23] + 
                byte_counts[32*i+7:32*i+24] + 
                byte_counts[32*i+6:32*i+25] + 
                byte_counts[32*i+5:32*i+26] + 
                byte_counts[32*i+4:32*i+27] + 
                byte_counts[32*i+3:32*i+28] + 
                byte_counts[32*i+2:32*i+29] + 
                byte_counts[32*i+1:32*i+30] + 
                byte_counts[32*i:32*i+31];
        end
    endgenerate

    // Calculate the final count
    assign out = {8{1'b0}} + 
        group_counts[0] + 
        group_counts[1] + 
        group_counts[2] + 
        group_counts[3] + 
        group_counts[4] + 
        group_counts[5] + 
        group_counts[6] + 
        group_counts[7];

endmodule