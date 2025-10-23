module TopModule (
    input [254:0] in,
    output [7:0] out
);

    // First, we need to count the number of '1's in each 8-bit group
    wire [31:0] count_8bit;
    genvar i;
    generate
        for (i = 0; i < 32; i++) begin
            wire [7:0] group;
            assign group = in[(i * 8) +: 8];
            wire [3:0] count;
            assign count = group[0] + group[1] + group[2] + group[3] +
                           group[4] + group[5] + group[6] + group[7];
            assign count_8bit[i] = count;
        end
    endgenerate

    // Next, we need to count the number of '1's in each 32-bit group (4 groups of 8 bits)
    wire [7:0] count_32bit;
    assign count_32bit = count_8bit[0] + count_8bit[1] + count_8bit[2] + count_8bit[3];

    // Now, we need to count the number of '1's in each 64-bit group (8 groups of 8 bits)
    wire [7:0] count_64bit;
    assign count_64bit = count_32bit + count_8bit[4] + count_8bit[5] + count_8bit[6] + count_8bit[7] +
                         count_8bit[8] + count_8bit[9] + count_8bit[10] + count_8bit[11];

    // Next, we need to count the number of '1's in each 128-bit group (16 groups of 8 bits)
    wire [7:0] count_128bit;
    assign count_128bit = count_64bit + count_8bit[16] + count_8bit[17] + count_8bit[18] + count_8bit[19] +
                          count_8bit[20] + count_8bit[21] + count_8bit[22] + count_8bit[23] +
                          count_8bit[24] + count_8bit[25] + count_8bit[26] + count_8bit[27] +
                          count_8bit[28] + count_8bit[29] + count_8bit[30] + count_8bit[31];

    // Finally, we need to count the total number of '1's in the 255-bit input vector
    assign out = {count_128bit[7:1], count_128bit[0] + count_8bit[0]};
endmodule