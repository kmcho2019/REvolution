module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Function to count the number of '1's in an 8-bit vector
    function [7:0] count_ones;
        input [7:0] vec;
        reg [7:0] count;
        begin
            count = 0;
            for (int i = 0; i < 8; i++) begin
                if (vec[i]) begin
                    count = count + 1;
                end
            end
            count_ones = count;
        end
    endfunction

    // Recursive function to combine counts using logarithmic number system
    function [7:0] combine_counts;
        input [7:0] count1, count2;
        begin
            combine_counts = count1 + count2;
        end
    endfunction

    // Divide the input into 32 blocks of 8 bits
    wire [7:0] block [31:0];

    // Assign the blocks
    genvar i;
    for (i = 0; i < 32; i++) begin
        if (i == 31) begin
            assign block[i] = {1'b0, in[254:248]};
        end else begin
            assign block[i] = in[(i*8)+7:i*8];
        end
    end

    // Count the number of '1's in each block
    wire [7:0] block_count [31:0];
    for (genvar i = 0; i < 32; i++) begin
        assign block_count[i] = count_ones(block[i]);
    end

    // Combine the counts using logarithmic number system
    wire [7:0] count_temp [4:0];
    assign count_temp[0] = block_count[0] + block_count[1] + block_count[2] + block_count[3] + block_count[4] + block_count[5] + block_count[6] + block_count[7];
    assign count_temp[1] = block_count[8] + block_count[9] + block_count[10] + block_count[11] + block_count[12] + block_count[13] + block_count[14] + block_count[15];
    assign count_temp[2] = block_count[16] + block_count[17] + block_count[18] + block_count[19] + block_count[20] + block_count[21] + block_count[22] + block_count[23];
    assign count_temp[3] = block_count[24] + block_count[25] + block_count[26] + block_count[27] + block_count[28] + block_count[29] + block_count[30] + block_count[31];
    assign count_temp[4] = count_temp[0] + count_temp[1] + count_temp[2] + count_temp[3];

    // Assign the output
    assign out = count_temp[4];

endmodule