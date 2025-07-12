module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Stage 0: Initial 1-bit counts (255 inputs)
    wire [254:0] count0 = in;

    // Stage 1: Sum pairs (127 results)
    wire [254:0] count1;
    genvar i;
    generate
        for (i = 0; i < 127; i = i + 1) begin : stage1
            assign count1[i] = count0[2*i] + count0[2*i+1];
        end
        assign count1[127] = count0[254]; // Handle odd bit
    endgenerate

    // Stage 2: Sum quads (64 results)
    wire [127:0] count2;
    generate
        for (i = 0; i < 63; i = i + 1) begin : stage2
            assign count2[i] = count1[2*i] + count1[2*i+1];
        end
        assign count2[63] = count1[126] + count1[127];
    endgenerate

    // Stage 3: Sum octets (32 results)
    wire [63:0] count3;
    generate
        for (i = 0; i < 31; i = i + 1) begin : stage3
            assign count3[i] = count2[2*i] + count2[2*i+1];
        end
        assign count3[31] = count2[62] + count2[63];
    endgenerate

    // Stage 4: Sum 16-bit groups (16 results)
    wire [31:0] count4;
    generate
        for (i = 0; i < 15; i = i + 1) begin : stage4
            assign count4[i] = count3[2*i] + count3[2*i+1];
        end
        assign count4[15] = count3[30] + count3[31];
    endgenerate

    // Stage 5: Sum 32-bit groups (8 results)
    wire [15:0] count5;
    generate
        for (i = 0; i < 7; i = i + 1) begin : stage5
            assign count5[i] = count4[2*i] + count4[2*i+1];
        end
        assign count5[7] = count4[14] + count4[15];
    endgenerate

    // Stage 6: Sum 64-bit groups (4 results)
    wire [7:0] count6;
    generate
        for (i = 0; i < 3; i = i + 1) begin : stage6
            assign count6[i] = count5[2*i] + count5[2*i+1];
        end
        assign count6[3] = count5[6] + count5[7];
    endgenerate

    // Stage 7: Sum 128-bit groups (2 results)
    wire [7:0] count7;
    assign count7[0] = count6[0] + count6[1];
    assign count7[1] = count6[2] + count6[3];

    // Final sum
    assign out = count7[0] + count7[1];

endmodule