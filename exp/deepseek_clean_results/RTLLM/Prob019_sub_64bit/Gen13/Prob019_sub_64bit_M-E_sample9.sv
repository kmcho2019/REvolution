module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement inversion with carry-in
    wire [63:0] B_comp = ~B;
    wire [63:0] B_comp_plus1 = B_comp + 64'd1;

    // Split into upper and lower 32-bit chunks
    wire [31:0] A_lo = A[31:0];
    wire [31:0] A_hi = A[63:32];
    wire [31:0] B_lo_comp = B_comp[31:0];
    wire [31:0] B_hi_comp = B_comp[63:32];
    wire [31:0] B_lo_comp_p1 = B_comp_plus1[31:0];
    wire [31:0] B_hi_comp_p1 = B_comp_plus1[63:32];

    // Lower 32-bit subtraction (two versions)
    wire [32:0] sum_lo_c0 = {1'b0, A_lo} + {1'b0, B_lo_comp};
    wire [32:0] sum_lo_c1 = {1'b0, A_lo} + {1'b0, B_lo_comp_p1};
    wire carry_out_lo = sum_lo_c1[32];

    // Upper 32-bit subtraction (parallel paths)
    wire [31:0] sum_hi_c0 = A_hi + B_hi_comp + 32'd0;
    wire [31:0] sum_hi_c1 = A_hi + B_hi_comp + 32'd1;

    // Final result muxing
    wire [31:0] sum_hi = carry_out_lo ? sum_hi_c1 : sum_hi_c0;
    assign result = {sum_hi, carry_out_lo ? sum_lo_c1[31:0] : sum_lo_c0[31:0]};

    // Early overflow prediction (analyze upper bits while lower bits compute)
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire res_sign = result[63];
    
    // Overflow when signs of A and ~B differ but result sign matches ~B sign
    wire overflow_cond1 = (A_sign == B_sign) && (res_sign != A_sign);
    
    // Additional check for extreme cases
    wire overflow_cond2 = (A_sign != B_sign) && 
                         ((A_sign && (A_hi == 32'h80000000) && (B_hi == 32'h7FFFFFFF)) ||
                         (!A_sign && (A_hi == 32'h7FFFFFFF) && (B_hi == 32'h80000000));
    
    assign overflow = overflow_cond1 | overflow_cond2;

endmodule