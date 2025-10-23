module TopModule(
    input  [254:0] in,
    output reg [7:0] out
);

    wire [7:0] count_2_127;
    genvar i;
    generate
        for (i = 0; i < 128; i = i + 1) begin
            // Create a 2:1 counter for each pair of bits
            always @(in)
                count_2_127[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    wire [6:0] count_4_63;
    generate
        for (i = 0; i < 64; i = i + 1) begin
            // Create a 2:1 counter for each pair of counts
            always @(count_2_127)
                count_4_63[i] = count_2_127[2*i] + count_2_127[2*i+1];
        end
    endgenerate

    wire [5:0] count_8_31;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            // Create a 2:1 counter for each pair of counts
            always @(count_4_63)
                count_8_31[i] = count_4_63[2*i] + count_4_63[2*i+1];
        end
    endgenerate

    wire [4:0] count_16_15;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            // Create a 2:1 counter for each pair of counts
            always @(count_8_31)
                count_16_15[i] = count_8_31[2*i] + count_8_31[2*i+1];
        end
    endgenerate

    wire [3:0] count_32_7;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            // Create a 2:1 counter for each pair of counts
            always @(count_16_15)
                count_32_7[i] = count_16_15[2*i] + count_16_15[2*i+1];
        end
    endgenerate

    wire [2:0] count_64_3;
    generate
        for (i = 0; i < 4; i = i + 1) begin
            // Create a 2:1 counter for each pair of counts
            always @(count_32_7)
                count_64_3[i] = count_32_7[2*i] + count_32_7[2*i+1];
        end
    endgenerate

    wire [1:0] count_128_1;
    generate
        for (i = 0; i < 2; i = i + 1) begin
            // Create a 2:1 counter for each pair of counts
            always @(count_64_3)
                count_128_1[i] = count_64_3[2*i] + count_64_3[2*i+1];
        end
    endgenerate

    always @(count_128_1)
        out = count_128_1[0] + count_128_1[1];

endmodule