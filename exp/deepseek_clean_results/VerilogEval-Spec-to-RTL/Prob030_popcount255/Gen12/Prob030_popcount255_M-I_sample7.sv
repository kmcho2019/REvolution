module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Pad input to 256 bits for uniform processing
    wire [255:0] padded_in = {1'b0, in};

    // Function to count '1's in 4 bits (LUT-based)
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

    // Count '1's in each 8-bit chunk using two 4-bit LUTs
    wire [3:0] partial_counts [0:31];
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : count_8bit_chunks
            wire [3:0] upper = padded_in[i*8 +: 4];
            wire [3:0] lower = padded_in[i*8+4 +: 4];
            assign partial_counts[i] = count4(upper) + count4(lower);
        end
    endgenerate

    // Balanced binary adder tree
    wire [7:0] stage1 [0:15];
    wire [7:0] stage2 [0:7];
    wire [7:0] stage3 [0:3];
    wire [7:0] stage4 [0:1];

    // First stage: Sum pairs of partial counts
    generate
        for (i = 0; i < 16; i = i + 1) begin : adder_stage1
            assign stage1[i] = partial_counts[i*2] + partial_counts[i*2+1];
        end
    endgenerate

    // Second stage
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_stage2
            assign stage2[i] = stage1[i*2] + stage1[i*2+1];
        end
    endgenerate

    // Third stage
    generate
        for (i = 0; i < 4; i = i + 1) begin : adder_stage3
            assign stage3[i] = stage2[i*2] + stage2[i*2+1];
        end
    endgenerate

    // Fourth stage
    generate
        for (i = 0; i < 2; i = i + 1) begin : adder_stage4
            assign stage4[i] = stage3[i*2] + stage3[i*2+1];
        end
    endgenerate

    // Final addition
    assign out = stage4[0] + stage4[1];

endmodule