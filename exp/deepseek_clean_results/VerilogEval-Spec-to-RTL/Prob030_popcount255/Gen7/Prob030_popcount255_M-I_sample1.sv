module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Pad input to 256 bits for uniform processing
    wire [255:0] padded_in = {1'b0, in};
    
    // First level: Count '1's in 4-bit chunks (64 chunks total)
    wire [2:0] count_4bit [0:63];
    
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : count_4bit_chunks
            // LUT-based counting for each 4-bit chunk
            always @(*) begin
                case (padded_in[i*4 +: 4])
                    4'b0000: count_4bit[i] = 3'd0;
                    4'b0001: count_4bit[i] = 3'd1;
                    4'b0010: count_4bit[i] = 3'd1;
                    4'b0011: count_4bit[i] = 3'd2;
                    4'b0100: count_4bit[i] = 3'd1;
                    4'b0101: count_4bit[i] = 3'd2;
                    4'b0110: count_4bit[i] = 3'd2;
                    4'b0111: count_4bit[i] = 3'd3;
                    4'b1000: count_4bit[i] = 3'd1;
                    4'b1001: count_4bit[i] = 3'd2;
                    4'b1010: count_4bit[i] = 3'd2;
                    4'b1011: count_4bit[i] = 3'd3;
                    4'b1100: count_4bit[i] = 3'd2;
                    4'b1101: count_4bit[i] = 3'd3;
                    4'b1110: count_4bit[i] = 3'd3;
                    4'b1111: count_4bit[i] = 3'd4;
                endcase
            end
        end
    endgenerate
    
    // Second level: Sum counts in a balanced binary tree
    // Level 1: Sum pairs of 4-bit counts (32 adders)
    wire [3:0] sum_level1 [0:31];
    generate
        for (i = 0; i < 32; i = i + 1) begin : level1_adders
            assign sum_level1[i] = count_4bit[i*2] + count_4bit[i*2+1];
        end
    endgenerate
    
    // Level 2: Sum pairs of level1 sums (16 adders)
    wire [4:0] sum_level2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level2_adders
            assign sum_level2[i] = sum_level1[i*2] + sum_level1[i*2+1];
        end
    endgenerate
    
    // Level 3: Sum pairs of level2 sums (8 adders)
    wire [5:0] sum_level3 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level3_adders
            assign sum_level3[i] = sum_level2[i*2] + sum_level2[i*2+1];
        end
    endgenerate
    
    // Level 4: Sum pairs of level3 sums (4 adders)
    wire [6:0] sum_level4 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level4_adders
            assign sum_level4[i] = sum_level3[i*2] + sum_level3[i*2+1];
        end
    endgenerate
    
    // Level 5: Sum pairs of level4 sums (2 adders)
    wire [7:0] sum_level5 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level5_adders
            assign sum_level5[i] = sum_level4[i*2] + sum_level4[i*2+1];
        end
    endgenerate
    
    // Final sum
    assign out = sum_level5[0] + sum_level5[1];

endmodule