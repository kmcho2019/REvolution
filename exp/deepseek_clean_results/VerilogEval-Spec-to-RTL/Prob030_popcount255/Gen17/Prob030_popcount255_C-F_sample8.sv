module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Pad input to 256 bits (next power of 2)
    wire [255:0] padded_in = {in, 1'b0};

    // Level 1: Count '1's in 4-bit chunks using LUT-style counting (64 chunks)
    function [2:0] count4;
        input [3:0] bits;
        begin
            case (bits)
                4'b0000: count4 = 3'd0;
                4'b0001: count4 = 3'd1;
                4'b0010: count4 = 3'd1;
                4'b0011: count4 = 3'd2;
                4'b0100: count4 = 3'd1;
                4'b0101: count4 = 3'd2;
                4'b0110: count4 = 3'd2;
                4'b0111: count4 = 3'd3;
                4'b1000: count4 = 3'd1;
                4'b1001: count4 = 3'd2;
                4'b1010: count4 = 3'd2;
                4'b1011: count4 = 3'd3;
                4'b1100: count4 = 3'd2;
                4'b1101: count4 = 3'd3;
                4'b1110: count4 = 3'd3;
                4'b1111: count4 = 3'd4;
            endcase
        end
    endfunction

    wire [2:0] level1 [0:63];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : level1_counters
            assign level1[i] = count4(padded_in[i*4 +: 4]);
        end
    endgenerate

    // Level 2: Sum 4 level1 counters (16 groups)
    wire [4:0] level2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level2_adders
            // Carry-save addition for better timing
            wire [3:0] sum1 = level1[i*4] + level1[i*4+1];
            wire [3:0] sum2 = level1[i*4+2] + level1[i*4+3];
            assign level2[i] = sum1 + sum2;
        end
    endgenerate

    // Level 3: Sum 4 level2 counters (4 groups)
    wire [6:0] level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level3_adders
            // Carry-save addition
            wire [5:0] sum1 = level2[i*4] + level2[i*4+1];
            wire [5:0] sum2 = level2[i*4+2] + level2[i*4+3];
            assign level3[i] = sum1 + sum2;
        end
    endgenerate

    // Final level: Balanced binary tree with CLA optimization
    wire [7:0] sum_ab = level3[0] + level3[1];
    wire [7:0] sum_cd = level3[2] + level3[3];
    assign out = sum_ab + sum_cd;

endmodule