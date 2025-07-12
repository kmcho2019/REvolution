module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Stage 0: Process bits [15:12]
    wire [11:0] rem_stage0;
    wire [3:0] quot_stage0;
    
    // Parallel comparisons for 4 bits
    wire [8:0] cmp0_3 = {1'b0, A[15:12], 4'b0} >= {B, 4'b0};
    wire [8:0] cmp0_2 = {1'b0, A[15:12], 3'b0} >= {B, 3'b0};
    wire [8:0] cmp0_1 = {1'b0, A[15:12], 2'b0} >= {B, 2'b0};
    wire [8:0] cmp0_0 = {1'b0, A[15:12], 1'b0} >= {B, 1'b0};
    
    // Quotient bits
    assign quot_stage0 = {cmp0_3[8], cmp0_2[8], cmp0_1[8], cmp0_0[8]};
    
    // Remainder calculation
    wire [8:0] sub0_3 = cmp0_3[8] ? {1'b0, A[15:12], 4'b0} - {B, 4'b0} : {1'b0, A[15:12], 4'b0};
    wire [8:0] sub0_2 = cmp0_2[8] ? sub0_3 - {B, 3'b0} : sub0_3;
    wire [8:0] sub0_1 = cmp0_1[8] ? sub0_2 - {B, 2'b0} : sub0_2;
    wire [8:0] sub0_0 = cmp0_0[8] ? sub0_1 - {B, 1'b0} : sub0_1;
    
    assign rem_stage0 = {sub0_0[7:0], A[11:0]};

    // Stage 1: Process bits [11:8]
    wire [7:0] rem_stage1;
    wire [3:0] quot_stage1;
    
    wire [8:0] cmp1_3 = {1'b0, rem_stage0[11:8], 4'b0} >= {B, 4'b0};
    wire [8:0] cmp1_2 = {1'b0, rem_stage0[11:8], 3'b0} >= {B, 3'b0};
    wire [8:0] cmp1_1 = {1'b0, rem_stage0[11:8], 2'b0} >= {B, 2'b0};
    wire [8:0] cmp1_0 = {1'b0, rem_stage0[11:8], 1'b0} >= {B, 1'b0};
    
    assign quot_stage1 = {cmp1_3[8], cmp1_2[8], cmp1_1[8], cmp1_0[8]};
    
    wire [8:0] sub1_3 = cmp1_3[8] ? {1'b0, rem_stage0[11:8], 4'b0} - {B, 4'b0} : {1'b0, rem_stage0[11:8], 4'b0};
    wire [8:0] sub1_2 = cmp1_2[8] ? sub1_3 - {B, 3'b0} : sub1_3;
    wire [8:0] sub1_1 = cmp1_1[8] ? sub1_2 - {B, 2'b0} : sub1_2;
    wire [8:0] sub1_0 = cmp1_0[8] ? sub1_1 - {B, 1'b0} : sub1_1;
    
    assign rem_stage1 = {sub1_0[7:0], rem_stage0[7:0]};

    // Stage 2: Process bits [7:4]
    wire [3:0] rem_stage2;
    wire [3:0] quot_stage2;
    
    wire [8:0] cmp2_3 = {1'b0, rem_stage1[7:4], 4'b0} >= {B, 4'b0};
    wire [8:0] cmp2_2 = {1'b0, rem_stage1[7:4], 3'b0} >= {B, 3'b0};
    wire [8:0] cmp2_1 = {1'b0, rem_stage1[7:4], 2'b0} >= {B, 2'b0};
    wire [8:0] cmp2_0 = {1'b0, rem_stage1[7:4], 1'b0} >= {B, 1'b0};
    
    assign quot_stage2 = {cmp2_3[8], cmp2_2[8], cmp2_1[8], cmp2_0[8]};
    
    wire [8:0] sub2_3 = cmp2_3[8] ? {1'b0, rem_stage1[7:4], 4'b0} - {B, 4'b0} : {1'b0, rem_stage1[7:4], 4'b0};
    wire [8:0] sub2_2 = cmp2_2[8] ? sub2_3 - {B, 3'b0} : sub2_3;
    wire [8:0] sub2_1 = cmp2_1[8] ? sub2_2 - {B, 2'b0} : sub2_2;
    wire [8:0] sub2_0 = cmp2_0[8] ? sub2_1 - {B, 1'b0} : sub2_1;
    
    assign rem_stage2 = {sub2_0[7:0], rem_stage1[3:0]};

    // Stage 3: Process bits [3:0]
    wire [3:0] quot_stage3;
    wire [7:0] final_rem;
    
    wire [8:0] cmp3_3 = {1'b0, rem_stage2[3:0], 4'b0} >= {B, 4'b0};
    wire [8:0] cmp3_2 = {1'b0, rem_stage2[3:0], 3'b0} >= {B, 3'b0};
    wire [8:0] cmp3_1 = {1'b0, rem_stage2[3:0], 2'b0} >= {B, 2'b0};
    wire [8:0] cmp3_0 = {1'b0, rem_stage2[3:0], 1'b0} >= {B, 1'b0};
    
    assign quot_stage3 = {cmp3_3[8], cmp3_2[8], cmp3_1[8], cmp3_0[8]};
    
    wire [8:0] sub3_3 = cmp3_3[8] ? {1'b0, rem_stage2[3:0], 4'b0} - {B, 4'b0} : {1'b0, rem_stage2[3:0], 4'b0};
    wire [8:0] sub3_2 = cmp3_2[8] ? sub3_3 - {B, 3'b0} : sub3_3;
    wire [8:0] sub3_1 = cmp3_1[8] ? sub3_2 - {B, 2'b0} : sub3_2;
    wire [8:0] sub3_0 = cmp3_0[8] ? sub3_1 - {B, 1'b0} : sub3_1;
    
    assign final_rem = sub3_0[7:0];

    // Combine results
    assign result = (B == 8'b0) ? 16'b0 : {quot_stage0, quot_stage1, quot_stage2, quot_stage3};
    assign odd = (B == 8'b0) ? 16'b0 : {{8{final_rem[7]}}, final_rem};

endmodule