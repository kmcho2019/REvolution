module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count '1's in 8-bit chunks (31 full bytes + 7 remaining bits)
    wire [3:0] byte_counts [0:30];  // 8 bits max 8 '1's -> 4 bits
    wire [2:0] rem_count;           // 7 bits max 7 '1's -> 3 bits

    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : byte_counters
            assign byte_counts[i] = 
                in[i*8 + 0] + in[i*8 + 1] + in[i*8 + 2] + in[i*8 + 3] +
                in[i*8 + 4] + in[i*8 + 5] + in[i*8 + 6] + in[i*8 + 7];
        end
    endgenerate

    // Count remaining 7 bits
    assign rem_count = 
        in[248] + in[249] + in[250] + in[251] +
        in[252] + in[253] + in[254];

    // Second level: Binary tree of adders
    // First stage: 16 adders (31 inputs -> 16 outputs)
    wire [4:0] stage1 [0:15];
    generate
        for (i = 0; i < 15; i = i + 1) begin : stage1_adders
            assign stage1[i] = byte_counts[i*2] + byte_counts[i*2 + 1];
        end
        assign stage1[15] = byte_counts[30] + rem_count;
    endgenerate

    // Second stage: 8 adders (16 inputs -> 8 outputs)
    wire [5:0] stage2 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_adders
            assign stage2[i] = stage1[i*2] + stage1[i*2 + 1];
        end
    endgenerate

    // Third stage: 4 adders (8 inputs -> 4 outputs)
    wire [6:0] stage3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : stage3_adders
            assign stage3[i] = stage2[i*2] + stage2[i*2 + 1];
        end
    endgenerate

    // Fourth stage: 2 adders (4 inputs -> 2 outputs)
    wire [7:0] stage4 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : stage4_adders
            assign stage4[i] = stage3[i*2] + stage3[i*2 + 1];
        end
    endgenerate

    // Final adder
    assign out = stage4[0] + stage4[1];

endmodule