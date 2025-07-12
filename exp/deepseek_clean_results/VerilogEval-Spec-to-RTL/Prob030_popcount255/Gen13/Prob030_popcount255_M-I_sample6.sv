module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // LUT-based 4-bit population count function
    function [2:0] popcount4;
        input [3:0] bits;
        begin
            case (bits)
                4'b0000: popcount4 = 3'd0;
                4'b0001: popcount4 = 3'd1;
                4'b0010: popcount4 = 3'd1;
                4'b0011: popcount4 = 3'd2;
                4'b0100: popcount4 = 3'd1;
                4'b0101: popcount4 = 3'd2;
                4'b0110: popcount4 = 3'd2;
                4'b0111: popcount4 = 3'd3;
                4'b1000: popcount4 = 3'd1;
                4'b1001: popcount4 = 3'd2;
                4'b1010: popcount4 = 3'd2;
                4'b1011: popcount4 = 3'd3;
                4'b1100: popcount4 = 3'd2;
                4'b1101: popcount4 = 3'd3;
                4'b1110: popcount4 = 3'd3;
                4'b1111: popcount4 = 3'd4;
            endcase
        end
    endfunction

    // First level: 64 groups of 4 bits (256 bits total, last group padded with 0)
    wire [2:0] level1 [0:63];
    genvar i;
    generate
        for (i = 0; i < 63; i = i + 1) begin : L1_COUNT
            assign level1[i] = popcount4(in[i*4 +: 4]);
        end
        // Last group (3 bits + 0 padding)
        assign level1[63] = popcount4({1'b0, in[254:252]});
    endgenerate

    // Second level: Sum pairs from level1 (32 groups)
    wire [3:0] level2 [0:31];
    genvar j;
    generate
        for (j = 0; j < 32; j = j + 1) begin : L2_SUM
            assign level2[j] = level1[j*2] + level1[j*2+1];
        end
    endgenerate

    // Third level: Sum pairs from level2 (16 groups)
    wire [4:0] level3 [0:15];
    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : L3_SUM
            assign level3[k] = level2[k*2] + level2[k*2+1];
        end
    endgenerate

    // Fourth level: Sum pairs from level3 (8 groups)
    wire [5:0] level4 [0:7];
    genvar l;
    generate
        for (l = 0; l < 8; l = l + 1) begin : L4_SUM
            assign level4[l] = level3[l*2] + level3[l*2+1];
        end
    endgenerate

    // Fifth level: Sum pairs from level4 (4 groups)
    wire [6:0] level5 [0:3];
    genvar m;
    generate
        for (m = 0; m < 4; m = m + 1) begin : L5_SUM
            assign level5[m] = level4[m*2] + level4[m*2+1];
        end
    endgenerate

    // Sixth level: Sum pairs from level5 (2 groups)
    wire [7:0] level6 [0:1];
    assign level6[0] = level5[0] + level5[1];
    assign level6[1] = level5[2] + level5[3];

    // Final sum
    assign out = level6[0] + level6[1];

endmodule