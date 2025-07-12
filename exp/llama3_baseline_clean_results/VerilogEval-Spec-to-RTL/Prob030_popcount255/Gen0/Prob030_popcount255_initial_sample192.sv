module TopModule(
    input  [255:0] in,
    output [7:0] out
);

    wire [7:0] count_8bit [31:0];

    // Count the number of '1's in each 8-bit chunk
    for (genvar i = 0; i < 32; i++) begin
        PopCount8Bit pop_count_8bit(
            .in(in + i*8 +: 8),
            .out(count_8bit[i])
        );
    end

    // Sum up the counts from each chunk
    wire [7:0] sum;
    assign sum = count_8bit[0] + count_8bit[1] + count_8bit[2] + count_8bit[3] +
                 count_8bit[4] + count_8bit[5] + count_8bit[6] + count_8bit[7] +
                 count_8bit[8] + count_8bit[9] + count_8bit[10] + count_8bit[11] +
                 count_8bit[12] + count_8bit[13] + count_8bit[14] + count_8bit[15] +
                 count_8bit[16] + count_8bit[17] + count_8bit[18] + count_8bit[19] +
                 count_8bit[20] + count_8bit[21] + count_8bit[22] + count_8bit[23] +
                 count_8bit[24] + count_8bit[25] + count_8bit[26] + count_8bit[27] +
                 count_8bit[28] + count_8bit[29] + count_8bit[30] + count_8bit[31];

    // Assign the sum to the output, limiting it to 8 bits
    assign out = sum[7:0];

endmodule

// Module to count the number of '1's in an 8-bit vector
module PopCount8Bit(
    input  [7:0] in,
    output [7:0] out
);

    assign out = {8{1'b0}} +
                 (in[0] ? 8'd1 : 8'd0) +
                 (in[1] ? 8'd1 : 8'd0) +
                 (in[2] ? 8'd1 : 8'd0) +
                 (in[3] ? 8'd1 : 8'd0) +
                 (in[4] ? 8'd1 : 8'd0) +
                 (in[5] ? 8'd1 : 8'd0) +
                 (in[6] ? 8'd1 : 8'd0) +
                 (in[7] ? 8'd1 : 8'd0);

endmodule