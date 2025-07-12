module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // LUT for 4-bit population count
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

    // Split into 64 groups of 4 bits (last group has 3 bits)
    wire [5:0] partial_counts [0:63];
    
    genvar i;
    generate
        for (i = 0; i < 63; i = i + 1) begin : COUNT_4BIT
            assign partial_counts[i] = popcount4(in[i*4+3:i*4]);
        end
        // Handle last 3-bit group
        assign partial_counts[63] = {3'b0, in[254]} + {3'b0, in[253]} + {3'b0, in[252]};
    endgenerate

    // Binary tree adder for final sum
    wire [7:0] stage1 [0:31];
    wire [7:0] stage2 [0:15];
    wire [7:0] stage3 [0:7];
    wire [7:0] stage4 [0:3];
    wire [7:0] stage5 [0:1];
    
    // Stage 1: Sum pairs of partial counts (64 -> 32)
    for (i = 0; i < 32; i = i + 1) begin : STAGE1
        assign stage1[i] = partial_counts[i*2] + partial_counts[i*2+1];
    end
    
    // Stage 2: Sum pairs (32 -> 16)
    for (i = 0; i < 16; i = i + 1) begin : STAGE2
        assign stage2[i] = stage1[i*2] + stage1[i*2+1];
    end
    
    // Stage 3: Sum pairs (16 -> 8)
    for (i = 0; i < 8; i = i + 1) begin : STAGE3
        assign stage3[i] = stage2[i*2] + stage2[i*2+1];
    end
    
    // Stage 4: Sum pairs (8 -> 4)
    for (i = 0; i < 4; i = i + 1) begin : STAGE4
        assign stage4[i] = stage3[i*2] + stage3[i*2+1];
    end
    
    // Stage 5: Sum pairs (4 -> 2)
    for (i = 0; i < 2; i = i + 1) begin : STAGE5
        assign stage5[i] = stage4[i*2] + stage4[i*2+1];
    end
    
    // Final sum (2 -> 1)
    assign out = stage5[0] + stage5[1];

endmodule