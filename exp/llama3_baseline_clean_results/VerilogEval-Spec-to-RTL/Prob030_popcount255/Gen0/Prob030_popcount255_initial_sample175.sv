module TopModule(
    input  [255:0] in,
    output [7:0] out
);

    // Count the number of '1's in each byte
    wire [7:0] count_bytes [31:0];
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            assign count_bytes[i] = {8{in[i*8+7:i*8]} & {8{1'b1}}};
        end
    endgenerate

    // Count the number of '1's in each byte
    wire [7:0] count_bytes_sum [3:0];
    assign count_bytes_sum[0] = count_bytes[0] + count_bytes[1] + count_bytes[2] + count_bytes[3] +
                               count_bytes[4] + count_bytes[5] + count_bytes[6] + count_bytes[7];
    assign count_bytes_sum[1] = count_bytes[8] + count_bytes[9] + count_bytes[10] + count_bytes[11] +
                               count_bytes[12] + count_bytes[13] + count_bytes[14] + count_bytes[15];
    assign count_bytes_sum[2] = count_bytes[16] + count_bytes[17] + count_bytes[18] + count_bytes[19] +
                               count_bytes[20] + count_bytes[21] + count_bytes[22] + count_bytes[23];
    assign count_bytes_sum[3] = count_bytes[24] + count_bytes[25] + count_bytes[26] + count_bytes[27] +
                               count_bytes[28] + count_bytes[29] + count_bytes[30] + count_bytes[31];

    // Count the number of '1's in each group of bytes
    wire [7:0] count_groups [1:0];
    assign count_groups[0] = count_bytes_sum[0] + count_bytes_sum[1];
    assign count_groups[1] = count_bytes_sum[2] + count_bytes_sum[3];

    // Count the total number of '1's
    wire [7:0] count_total;
    assign count_total = count_groups[0] + count_groups[1];

    // Output the total count
    assign out = count_total;

endmodule