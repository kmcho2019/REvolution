module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Internal signals for carry-select architecture
    wire [3:0] carry;
    wire [3:0] ovfl_chunk;
    wire [63:0] B_comp = ~B + 1;  // Two's complement of B
    
    // Generate 4x16-bit chunks with carry-select
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : chunk
            // Local signals for each chunk
            wire [15:0] sum0, sum1;
            wire [15:0] A_chunk = A[i*16 +: 16];
            wire [15:0] B_chunk = B_comp[i*16 +: 16];
            
            // Compute both possible results (carry=0 and carry=1)
            assign sum0 = A_chunk + B_chunk;
            assign sum1 = A_chunk + B_chunk + 1;
            
            // Select appropriate result based on carry-in
            if (i == 0) begin
                assign result[15:0] = sum0;  // First chunk never has carry-in
                assign carry[0] = (A_chunk[15] == B_chunk[15]) && 
                                 (sum0[15] != A_chunk[15]);
            end else begin
                assign result[i*16 +: 16] = carry[i-1] ? sum1 : sum0;
                assign carry[i] = (A_chunk[15] == B_chunk[15]) && 
                                 ((carry[i-1] ? sum1[15] : sum0[15]) != A_chunk[15]);
            end
            
            // Early overflow detection per chunk
            assign ovfl_chunk[i] = (A_chunk[15] != B_chunk[15]) && 
                                  ((carry[i-1] ? sum1[15] : sum0[15]) != A_chunk[15]);
        end
    endgenerate
    
    // Combine overflow signals (overflow in any chunk is global overflow)
    assign overflow = |ovfl_chunk;

endmodule