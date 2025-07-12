module TopModule(
    input  [254:0] in,  // 255-bit input vector
    output [7:0] out   // 8-bit output
);

    // Count the number of '1's in each byte (8-bit chunk)
    wire [7:0] byte_counts [31:0];
    genvar i;
    generate
        for (i = 0; i < 32; i++) begin
            assign byte_counts[i] = {1'b0, in[8*i+7:8*i]} + {8{1'b1}} - 1;
        end
    endgenerate

    // Add up the counts in groups of 8 bytes
    wire [7:0] group_counts [3:0];
    assign group_counts[0] = byte_counts[0] + byte_counts[1] + byte_counts[2] + byte_counts[3] +
                            byte_counts[4] + byte_counts[5] + byte_counts[6] + byte_counts[7];
    assign group_counts[1] = byte_counts[8] + byte_counts[9] + byte_counts[10] + byte_counts[11] +
                            byte_counts[12] + byte_counts[13] + byte_counts[14] + byte_counts[15];
    assign group_counts[2] = byte_counts[16] + byte_counts[17] + byte_counts[18] + byte_counts[19] +
                            byte_counts[20] + byte_counts[21] + byte_counts[22] + byte_counts[23];
    assign group_counts[3] = byte_counts[24] + byte_counts[25] + byte_counts[26] + byte_counts[27] +
                            byte_counts[28] + byte_counts[29] + byte_counts[30] + byte_counts[31];

    // Add up the counts in groups of 8
    reg [7:0] temp_count;
    always @(group_counts) begin
        temp_count = group_counts[0] + group_counts[1] + group_counts[2] + group_counts[3];
    end

    // Assign the final count to the output
    assign out = temp_count;

endmodule