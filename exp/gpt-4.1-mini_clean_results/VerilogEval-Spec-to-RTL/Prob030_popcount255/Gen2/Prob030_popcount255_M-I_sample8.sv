module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Stage 0: input bits as 1-bit partial sums
    wire [254:0] stage0 = in;

    // Stage 1: sum pairs -> 127 sums of 2 bits, plus 1 leftover
    wire [1:0] stage1 [0:126];
    wire [0:0] leftover1 = stage0[254];
    genvar i;
    generate
        for (i = 0; i < 127; i = i + 1) begin : gen_stage1
            assign stage1[i] = stage0[2*i] + stage0[2*i+1];
        end
    endgenerate

    // Stage 2: sum pairs of 2-bit sums from stage1 -> 63 sums of 3 bits, plus 1 leftover
    wire [2:0] stage2 [0:62];
    wire [1:0] leftover2 = stage1[126];
    generate
        for (i = 0; i < 63; i = i + 1) begin : gen_stage2
            assign stage2[i] = stage1[2*i] + stage1[2*i+1];
        end
    endgenerate

    // Stage 3: sum pairs of 3-bit sums -> 31 sums of 4 bits, plus 1 leftover
    wire [3:0] stage3 [0:30];
    wire [2:0] leftover3 = stage2[62];
    generate
        for (i = 0; i < 31; i = i + 1) begin : gen_stage3
            assign stage3[i] = stage2[2*i] + stage2[2*i+1];
        end
    endgenerate

    // Stage 4: sum pairs of 4-bit sums -> 15 sums of 5 bits, plus 1 leftover
    wire [4:0] stage4 [0:14];
    wire [3:0] leftover4 = stage3[30];
    generate
        for (i = 0; i < 15; i = i + 1) begin : gen_stage4
            assign stage4[i] = stage3[2*i] + stage3[2*i+1];
        end
    endgenerate

    // Stage 5: sum pairs of 5-bit sums -> 7 sums of 6 bits, plus 1 leftover
    wire [5:0] stage5 [0:6];
    wire [4:0] leftover5 = stage4[14];
    generate
        for (i = 0; i < 7; i = i + 1) begin : gen_stage5
            assign stage5[i] = stage4[2*i] + stage4[2*i+1];
        end
    endgenerate

    // Stage 6: sum pairs of 6-bit sums -> 3 sums of 7 bits, plus 1 leftover
    wire [6:0] stage6 [0:2];
    wire [5:0] leftover6 = stage5[6];
    generate
        for (i = 0; i < 3; i = i + 1) begin : gen_stage6
            assign stage6[i] = stage5[2*i] + stage5[2*i+1];
        end
    endgenerate

    // Stage 7: sum pairs of 7-bit sums -> 1 sum of 8 bits, plus 1 leftover
    wire [7:0] stage7;
    wire [6:0] leftover7 = stage6[2];
    assign stage7 = stage6[0] + stage6[1];

    // Final summation: sum leftover signals plus stage7
    // leftover7 is 7 bits, leftover6 is 6 bits, etc.
    // We'll sum all leftovers plus stage7, extending them to 8 bits
    wire [7:0] sum_leftovers;
    assign sum_leftovers =
        {1'b0, leftover7} +    // 8 bits (leftover7 is 7 bits)
        {2'b00, leftover6} +   // 8 bits
        {3'b000, leftover5} +  // 8 bits
        {4'b0000, leftover4} + // 8 bits
        {5'b00000, leftover3} +// 8 bits
        {6'b000000, leftover2} +// 8 bits
        {7'b0000000, leftover1}; // 8 bits

    assign out = stage7 + sum_leftovers;

endmodule