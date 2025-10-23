module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Function to count 1s in 4 bits using LUT
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

    // Process in 8-bit chunks (32 chunks total, last one zero-padded)
    wire [3:0] chunk_counts [0:31];
    
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : process_chunks
            wire [7:0] chunk;
            // Zero-pad the last chunk if needed
            assign chunk = (i == 31) ? {1'b0, in[254:248]} : in[i*8 +: 8];
            
            // Count using two 4-bit LUTs
            wire [2:0] cnt_lo = count4(chunk[3:0]);
            wire [2:0] cnt_hi = count4(chunk[7:4]);
            
            assign chunk_counts[i] = cnt_lo + cnt_hi;
        end
    endgenerate

    // Balanced adder tree for final summation
    wire [7:0] level1 [0:15];
    wire [7:0] level2 [0:7];
    wire [7:0] level3 [0:3];
    wire [7:0] level4 [0:1];
    
    // Level 1: Sum pairs of chunk counts
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_level1
            assign level1[i] = chunk_counts[i*2] + chunk_counts[i*2 + 1];
        end
    endgenerate
    
    // Level 2
    generate
        for (i = 0; i < 8; i = i + 1) begin : sum_level2
            assign level2[i] = level1[i*2] + level1[i*2 + 1];
        end
    endgenerate
    
    // Level 3
    generate
        for (i = 0; i < 4; i = i + 1) begin : sum_level3
            assign level3[i] = level2[i*2] + level2[i*2 + 1];
        end
    endgenerate
    
    // Level 4
    generate
        for (i = 0; i < 2; i = i + 1) begin : sum_level4
            assign level4[i] = level3[i*2] + level3[i*2 + 1];
        end
    endgenerate
    
    // Final sum
    assign out = level4[0] + level4[1];

endmodule