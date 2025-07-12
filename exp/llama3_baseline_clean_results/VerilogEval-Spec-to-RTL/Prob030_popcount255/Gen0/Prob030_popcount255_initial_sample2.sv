module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    wire [7:0] count_8bit [31:0];
    wire [7:0] count_64bit [3:0];
    wire [7:0] count_192bit [1:0];
    wire [7:0] count;

    // Count the number of '1's in each 8-bit chunk
    genvar i;
    generate
        for (i = 0; i < 32; i++) begin
            assign count_8bit[i] = {8{1'b0}};
            for (int j = 0; j < 8; j++) begin
                assign count_8bit[i][j] = in[i*8 + j];
            end
            assign count_8bit[i] = {count_8bit[i][7:0] + 1'b0};
            assign count_8bit[i] = count_8bit[i] + {8{1'b0}};
        end
    endgenerate

    // Count the number of '1's in each 64-bit chunk
    assign count_64bit[0] = count_8bit[0] + count_8bit[1] + count_8bit[2] + count_8bit[3] +
                           count_8bit[4] + count_8bit[5] + count_8bit[6] + count_8bit[7];
    assign count_64bit[1] = count_8bit[8] + count_8bit[9] + count_8bit[10] + count_8bit[11] +
                           count_8bit[12] + count_8bit[13] + count_8bit[14] + count_8bit[15];
    assign count_64bit[2] = count_8bit[16] + count_8bit[17] + count_8bit[18] + count_8bit[19] +
                           count_8bit[20] + count_8bit[21] + count_8bit[22] + count_8bit[23];
    assign count_64bit[3] = count_8bit[24] + count_8bit[25] + count_8bit[26] + count_8bit[27] +
                           count_8bit[28] + count_8bit[29] + count_8bit[30] + count_8bit[31];

    // Count the number of '1's in each 192-bit chunk
    assign count_192bit[0] = count_64bit[0] + count_64bit[1];
    assign count_192bit[1] = count_64bit[2] + count_64bit[3];

    // Count the number of '1's in the 255-bit input vector
    assign count = count_192bit[0] + count_192bit[1];

    // Assign the final count to the output
    assign out = count[7:0];

endmodule