module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: sum every bit (1-bit adders)
    wire [254:0] bit_counts = in;

    // Second level: sum pairs (2-bit adders)
    wire [126:0] [1:0] sum2;
    genvar i;
    generate
        for (i = 0; i < 127; i = i + 1) begin : sum2_gen
            assign sum2[i] = bit_counts[2*i] + bit_counts[2*i+1];
        end
        // Handle the last odd bit
        wire [0:0] sum2_odd = bit_counts[254];
    endgenerate

    // Third level: sum 4-bit groups (3-bit adders)
    wire [63:0] [2:0] sum4;
    generate
        for (i = 0; i < 63; i = i + 1) begin : sum4_gen
            assign sum4[i] = sum2[2*i] + sum2[2*i+1];
        end
        // Handle the remaining sums (last 2 sums + odd bit)
        wire [1:0] sum4_remain = sum2[126] + sum2_odd;
    endgenerate

    // Fourth level: sum 8-bit groups (4-bit adders)
    wire [31:0] [3:0] sum8;
    generate
        for (i = 0; i < 31; i = i + 1) begin : sum8_gen
            assign sum8[i] = sum4[2*i] + sum4[2*i+1];
        end
        // Handle remaining sums (last sum4 + sum4_remain)
        wire [3:0] sum8_remain = sum4[63] + sum4_remain;
    endgenerate

    // Fifth level: sum 16-bit groups (5-bit adders)
    wire [15:0] [4:0] sum16;
    generate
        for (i = 0; i < 15; i = i + 1) begin : sum16_gen
            assign sum16[i] = sum8[2*i] + sum8[2*i+1];
        end
        // Handle remaining sums
        wire [4:0] sum16_remain = sum8[31] + sum8_remain;
    endgenerate

    // Sixth level: sum 32-bit groups (6-bit adders)
    wire [7:0] [5:0] sum32;
    generate
        for (i = 0; i < 7; i = i + 1) begin : sum32_gen
            assign sum32[i] = sum16[2*i] + sum16[2*i+1];
        end
        // Handle remaining sums
        wire [5:0] sum32_remain = sum16[15] + sum16_remain;
    endgenerate

    // Seventh level: sum 64-bit groups (7-bit adders)
    wire [3:0] [6:0] sum64;
    generate
        for (i = 0; i < 3; i = i + 1) begin : sum64_gen
            assign sum64[i] = sum32[2*i] + sum32[2*i+1];
        end
        // Handle remaining sums
        wire [6:0] sum64_remain = sum32[7] + sum32_remain;
    endgenerate

    // Eighth level: sum 128-bit groups (8-bit adders)
    wire [1:0] [7:0] sum128;
    generate
        for (i = 0; i < 1; i = i + 1) begin : sum128_gen
            assign sum128[i] = sum64[2*i] + sum64[2*i+1];
        end
        // Handle remaining sums
        wire [7:0] sum128_remain = sum64[3] + sum64_remain;
    endgenerate

    // Final sum (255 bits)
    assign out = sum128[0] + sum128_remain;

endmodule