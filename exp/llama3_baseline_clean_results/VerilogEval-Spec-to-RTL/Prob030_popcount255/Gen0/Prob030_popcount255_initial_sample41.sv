module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Count the number of '1's in each 8-bit chunk
    wire [7:0] chunk_counts [31:0];
    genvar i;
    generate
        for (i = 0; i < 32; i++) begin
            assign chunk_counts[i] = in[8*i+7:8*i] + in[8*i+6:8*i+5] + in[8*i+4:8*i+3] + in[8*i+2:8*i+1] + in[8*i+1:8*i];
        end
    endgenerate

    // Add up the counts of the 8-bit chunks
    reg [7:0] temp_counts [15:0];
    integer j;
    always @(*) begin
        temp_counts[0] = chunk_counts[0] + chunk_counts[1];
        temp_counts[1] = chunk_counts[2] + chunk_counts[3];
        temp_counts[2] = chunk_counts[4] + chunk_counts[5];
        temp_counts[3] = chunk_counts[6] + chunk_counts[7];
        temp_counts[4] = chunk_counts[8] + chunk_counts[9];
        temp_counts[5] = chunk_counts[10] + chunk_counts[11];
        temp_counts[6] = chunk_counts[12] + chunk_counts[13];
        temp_counts[7] = chunk_counts[14] + chunk_counts[15];
        temp_counts[8] = chunk_counts[16] + chunk_counts[17];
        temp_counts[9] = chunk_counts[18] + chunk_counts[19];
        temp_counts[10] = chunk_counts[20] + chunk_counts[21];
        temp_counts[11] = chunk_counts[22] + chunk_counts[23];
        temp_counts[12] = chunk_counts[24] + chunk_counts[25];
        temp_counts[13] = chunk_counts[26] + chunk_counts[27];
        temp_counts[14] = chunk_counts[28] + chunk_counts[29];
        temp_counts[15] = chunk_counts[30] + chunk_counts[31];

        out = temp_counts[0] + temp_counts[1] + temp_counts[2] + temp_counts[3] + temp_counts[4] + temp_counts[5] + temp_counts[6] + temp_counts[7] + 
              temp_counts[8] + temp_counts[9] + temp_counts[10] + temp_counts[11] + temp_counts[12] + temp_counts[13] + temp_counts[14] + temp_counts[15];
    end
endmodule