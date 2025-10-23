module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Segment the 64-bit inputs into four 16-bit chunks
    wire signed [15:0] A3 = A[63:48];
    wire signed [15:0] A2 = A[47:32];
    wire signed [15:0] A1 = A[31:16];
    wire signed [15:0] A0 = A[15:0];
    
    wire signed [15:0] B3 = B[63:48];
    wire signed [15:0] B2 = B[47:32];
    wire signed [15:0] B1 = B[31:16];
    wire signed [15:0] B0 = B[15:0];
    
    // Intermediate results and carries
    wire signed [16:0] sum0, sum1, sum2, sum3;
    wire cout0, cout1, cout2;
    
    // Perform segmented subtraction with carry propagation
    assign sum0 = {A0[15], A0} - {B0[15], B0} - 0;
    assign cout0 = sum0[16];
    
    assign sum1 = {A1[15], A1} - {B1[15], B1} - cout0;
    assign cout1 = sum1[16];
    
    assign sum2 = {A2[15], A2} - {B2[15], B2} - cout1;
    assign cout2 = sum2[16];
    
    assign sum3 = {A3[15], A3} - {B3[15], B3} - cout2;
    
    // Combine results
    assign result = {sum3[15:0], sum2[15:0], sum1[15:0], sum0[15:0]};
    
    // Overflow detection (same logic but computed in parallel)
    wire overflow_parallel = (A3[15] ^ B3[15]) && (A3[15] ^ sum3[15]);
    assign overflow = overflow_parallel;

endmodule