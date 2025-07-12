module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Pad input to 256 bits for uniform processing
    wire [255:0] padded_in = {in, 1'b0};
    
    // Function to count 1s in 4-bit chunks (LUT-based)
    function [2:0] count4;
        input [3:0] bits;
        begin
            case (bits)
                4'b0000: count4 = 3'b000;
                4'b0001: count4 = 3'b001;
                4'b0010: count4 = 3'b001;
                4'b0011: count4 = 3'b010;
                4'b0100: count4 = 3'b001;
                4'b0101: count4 = 3'b010;
                4'b0110: count4 = 3'b010;
                4'b0111: count4 = 3'b011;
                4'b1000: count4 = 3'b001;
                4'b1001: count4 = 3'b010;
                4'b1010: count4 = 3'b010;
                4'b1011: count4 = 3'b011;
                4'b1100: count4 = 3'b010;
                4'b1101: count4 = 3'b011;
                4'b1110: count4 = 3'b011;
                4'b1111: count4 = 3'b100;
            endcase
        end
    endfunction

    // First level: Count 1s in 4-bit chunks (64 chunks)
    wire [5:0] level1 [0:63];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : level1_count
            assign level1[i] = {3'b0, count4(padded_in[i*4 +: 4])};
        end
    endgenerate

    // Second level: Sum pairs of level1 counts (32 adders)
    wire [6:0] level2 [0:31];
    genvar j;
    generate
        for (j = 0; j < 32; j = j + 1) begin : level2_sum
            assign level2[j] = level1[j*2] + level1[j*2 + 1];
        end
    endgenerate

    // Third level: Sum pairs of level2 counts (16 adders)
    wire [7:0] level3 [0:15];
    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : level3_sum
            assign level3[k] = level2[k*2] + level2[k*2 + 1];
        end
    endgenerate

    // Fourth level: Sum pairs of level3 counts (8 adders)
    wire [7:0] level4 [0:7];
    genvar l;
    generate
        for (l = 0; l < 8; l = l + 1) begin : level4_sum
            assign level4[l] = level3[l*2] + level3[l*2 + 1];
        end
    endgenerate

    // Fifth level: Sum pairs of level4 counts (4 adders)
    wire [7:0] level5 [0:3];
    genvar m;
    generate
        for (m = 0; m < 4; m = m + 1) begin : level5_sum
            assign level5[m] = level4[m*2] + level4[m*2 + 1];
        end
    endgenerate

    // Sixth level: Sum pairs of level5 counts (2 adders)
    wire [7:0] level6 [0:1];
    assign level6[0] = level5[0] + level5[1];
    assign level6[1] = level5[2] + level5[3];

    // Final sum
    assign out = level6[0] + level6[1];

endmodule