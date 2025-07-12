module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    // Calculate population count for each byte
    wire [7:0] byte_counts [31:0];
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : byte_count_gen
            assign byte_counts[i] = {8{1'b0}} + in[i*8+7] + in[i*8+6] + in[i*8+5] + in[i*8+4] + in[i*8+3] + in[i*8+2] + in[i*8+1] + in[i*8];
        end
    endgenerate

    // Calculate population count for each 32-bit word
    wire [7:0] word_counts [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : word_count_gen
            assign word_counts[i] = byte_counts[i*4+3] + byte_counts[i*4+2] + byte_counts[i*4+1] + byte_counts[i*4];
        end
    endgenerate

    // Calculate population count for each 64-bit double word
    wire [7:0] double_word_counts [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : double_word_count_gen
            assign double_word_counts[i] = word_counts[i*2+1] + word_counts[i*2];
        end
    endgenerate

    // Calculate population count for each 128-bit quad word
    wire [7:0] quad_word_counts [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : quad_word_count_gen
            assign quad_word_counts[i] = double_word_counts[i*2+1] + double_word_counts[i*2];
        end
    endgenerate

    // Calculate final population count
    assign out = quad_word_counts[1] + quad_word_counts[0];

endmodule