module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Handle division by zero case first
    wire zero_divisor = (B == 8'b0);
    
    // Initialize working remainder
    wire [8:0] initial_rem = zero_divisor ? 9'b0 : {1'b0, A[15]};
    
    // Process each bit stage
    wire [8:0] rem_stage15 = (initial_rem >= {1'b0, B}) ? 
                            (initial_rem - {1'b0, B}) : initial_rem;
    wire [8:0] rem_stage14 = {rem_stage15[7:0], A[14]};
    wire [8:0] rem_stage13 = {rem_stage14[7:0], A[13]};
    wire [8:0] rem_stage12 = {rem_stage13[7:0], A[12]};
    wire [8:0] rem_stage11 = {rem_stage12[7:0], A[11]};
    wire [8:0] rem_stage10 = {rem_stage11[7:0], A[10]};
    wire [8:0] rem_stage9  = {rem_stage10[7:0], A[9]};
    wire [8:0] rem_stage8  = {rem_stage9[7:0], A[8]};
    wire [8:0] rem_stage7  = {rem_stage8[7:0], A[7]};
    wire [8:0] rem_stage6  = {rem_stage7[7:0], A[6]};
    wire [8:0] rem_stage5  = {rem_stage6[7:0], A[5]};
    wire [8:0] rem_stage4  = {rem_stage5[7:0], A[4]};
    wire [8:0] rem_stage3  = {rem_stage4[7:0], A[3]};
    wire [8:0] rem_stage2  = {rem_stage3[7:0], A[2]};
    wire [8:0] rem_stage1  = {rem_stage2[7:0], A[1]};
    wire [8:0] rem_stage0  = {rem_stage1[7:0], A[0]};
    
    // Compute quotient bits
    assign result[15] = (initial_rem >= {1'b0, B}) & ~zero_divisor;
    assign result[14] = (rem_stage14 >= {1'b0, B}) & ~zero_divisor;
    assign result[13] = (rem_stage13 >= {1'b0, B}) & ~zero_divisor;
    assign result[12] = (rem_stage12 >= {1'b0, B}) & ~zero_divisor;
    assign result[11] = (rem_stage11 >= {1'b0, B}) & ~zero_divisor;
    assign result[10] = (rem_stage10 >= {1'b0, B}) & ~zero_divisor;
    assign result[9]  = (rem_stage9  >= {1'b0, B}) & ~zero_divisor;
    assign result[8]  = (rem_stage8  >= {1'b0, B}) & ~zero_divisor;
    assign result[7]  = (rem_stage7  >= {1'b0, B}) & ~zero_divisor;
    assign result[6]  = (rem_stage6  >= {1'b0, B}) & ~zero_divisor;
    assign result[5]  = (rem_stage5  >= {1'b0, B}) & ~zero_divisor;
    assign result[4]  = (rem_stage4  >= {1'b0, B}) & ~zero_divisor;
    assign result[3]  = (rem_stage3  >= {1'b0, B}) & ~zero_divisor;
    assign result[2]  = (rem_stage2  >= {1'b0, B}) & ~zero_divisor;
    assign result[1]  = (rem_stage1  >= {1'b0, B}) & ~zero_divisor;
    assign result[0]  = (rem_stage0  >= {1'b0, B}) & ~zero_divisor;
    
    // Final remainder output
    assign odd = zero_divisor ? 8'b0 : rem_stage0[7:0];

endmodule