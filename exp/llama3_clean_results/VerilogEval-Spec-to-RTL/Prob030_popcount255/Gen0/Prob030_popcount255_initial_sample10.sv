module TopModule(
    input  [255:0] in,
    output [7:0] out
);

    wire [7:0] byte_counts [31:0];

    // Count the number of '1's in each byte
    for (genvar i = 0; i < 32; i++) begin
        assign byte_counts[i] = {8{in[8*i+7:8*i]} & 8'b1} + 
                               {8{in[8*i+6:8*i+1]} & 8'b1} + 
                               {8{in[8*i+5:8*i+2]} & 8'b1} + 
                               {8{in[8*i+4:8*i+3]} & 8'b1};
    end

    // Sum up the counts from each byte
    assign out = byte_counts[0] + byte_counts[1] + byte_counts[2] + byte_counts[3] +
                 byte_counts[4] + byte_counts[5] + byte_counts[6] + byte_counts[7] +
                 byte_counts[8] + byte_counts[9] + byte_counts[10] + byte_counts[11] +
                 byte_counts[12] + byte_counts[13] + byte_counts[14] + byte_counts[15] +
                 byte_counts[16] + byte_counts[17] + byte_counts[18] + byte_counts[19] +
                 byte_counts[20] + byte_counts[21] + byte_counts[22] + byte_counts[23] +
                 byte_counts[24] + byte_counts[25] + byte_counts[26] + byte_counts[27] +
                 byte_counts[28] + byte_counts[29] + byte_counts[30] + byte_counts[31];

endmodule