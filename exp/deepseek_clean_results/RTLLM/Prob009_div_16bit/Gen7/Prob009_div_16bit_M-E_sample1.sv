module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Parallel comparison units (4-bit slices)
    wire [3:0] cmp_high, cmp_mid, cmp_low, cmp_lowest;
    wire [11:0] partial_remainders [0:3];
    wire [11:0] shifted_dividend [0:3];
    
    // First level: Compare 4-bit slices of the dividend
    assign cmp_high = {4{A[15:12] >= B[7:4]}};
    assign cmp_mid = {4{A[11:8] >= B[7:4]}};
    assign cmp_low = {4{A[7:4] >= B[7:4]}};
    assign cmp_lowest = {4{A[3:0] >= B[7:4]}};
    
    // Compute partial remainders in parallel
    assign partial_remainders[0] = (A[15:12] >= B[7:4]) ? (A[15:12] - B[7:4]) : A[15:12];
    assign partial_remainders[1] = (A[11:8] >= B[7:4]) ? (A[11:8] - B[7:4]) : A[11:8];
    assign partial_remainders[2] = (A[7:4] >= B[7:4]) ? (A[7:4] - B[7:4]) : A[7:4];
    assign partial_remainders[3] = (A[3:0] >= B[7:4]) ? (A[3:0] - B[7:4]) : A[3:0];
    
    // Shift and combine remainders with next bits
    assign shifted_dividend[0] = {partial_remainders[0], A[11:8]};
    assign shifted_dividend[1] = {partial_remainders[1], A[7:4]};
    assign shifted_dividend[2] = {partial_remainders[2], A[3:0]};
    assign shifted_dividend[3] = {partial_remainders[3], 4'b0};
    
    // Second level: Compare 8-bit chunks
    wire [7:0] cmp_8bit [0:1];
    wire [7:0] rem_8bit [0:1];
    
    assign cmp_8bit[0] = {4{shifted_dividend[0][11:4] >= B}};
    assign cmp_8bit[1] = {4{shifted_dividend[2][11:4] >= B}};
    
    assign rem_8bit[0] = (shifted_dividend[0][11:4] >= B) ? 
                         (shifted_dividend[0][11:4] - B) : shifted_dividend[0][11:4];
    assign rem_8bit[1] = (shifted_dividend[2][11:4] >= B) ? 
                         (shifted_dividend[2][11:4] - B) : shifted_dividend[2][11:4];
    
    // Final quotient assembly
    assign result[15:12] = cmp_high & {4{cmp_8bit[0][3]}};
    assign result[11:8] = cmp_mid & {4{cmp_8bit[0][2]}};
    assign result[7:4] = cmp_low & {4{cmp_8bit[1][1]}};
    assign result[3:0] = cmp_lowest & {4{cmp_8bit[1][0]}};
    
    // Final remainder calculation
    wire [7:0] final_rem;
    assign final_rem = (rem_8bit[1] >= B) ? (rem_8bit[1] - B) : rem_8bit[1];
    assign odd = {8'b0, final_rem};

endmodule