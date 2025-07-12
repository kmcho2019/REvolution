module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Pre-scale inputs to align MSBs
    wire [15:0] scaled_A = A << (16 - $clog2(B+1));
    wire [15:0] scaled_B = B << (16 - $clog2(B+1));

    // Recursive doubling stages
    wire [15:0] quotient [0:3];
    wire [15:0] remainder [0:3];
    
    // Stage 0: Initial comparison (8-bit chunks)
    assign quotient[0] = (scaled_A[15:8] >= scaled_B[15:8]) ? 16'h0100 : 16'h0000;
    assign remainder[0] = (scaled_A[15:8] >= scaled_B[15:8]) ? 
                         {scaled_A[15:8] - scaled_B[15:8], scaled_A[7:0]} : 
                         scaled_A;

    // Stage 1: 4-bit refinement
    wire [11:0] rem_1 = {remainder[0][7:0], 4'b0};
    assign quotient[1] = quotient[0] | 
                        ((rem_1[11:8] >= scaled_B[15:12]) ? 16'h0080 : 16'h0000);
    assign remainder[1] = (rem_1[11:8] >= scaled_B[15:12]) ?
                         {rem_1[11:8] - scaled_B[15:12], rem_1[7:0]} :
                         rem_1;

    // Stage 2: 2-bit refinement
    wire [13:0] rem_2 = {remainder[1][7:0], 2'b0};
    assign quotient[2] = quotient[1] | 
                        ((rem_2[13:12] >= scaled_B[15:14]) ? 16'h0020 : 16'h0000);
    assign remainder[2] = (rem_2[13:12] >= scaled_B[15:14]) ?
                         {rem_2[13:12] - scaled_B[15:14], rem_2[11:0]} :
                         rem_2;

    // Stage 3: Final 1-bit refinement
    wire [14:0] rem_3 = {remainder[2][7:0], 1'b0};
    assign quotient[3] = quotient[2] | 
                        ((rem_3[14] >= scaled_B[15]) ? 16'h0010 : 16'h0000);
    assign remainder[3] = (rem_3[14] >= scaled_B[15]) ?
                         {rem_3[14] - scaled_B[15], rem_3[13:0]} :
                         rem_3;

    // Final results
    assign result = quotient[3] >> (16 - $clog2(B+1));
    assign odd = remainder[3] >> (16 - $clog2(B+1));

endmodule