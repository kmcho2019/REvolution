module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Early overflow prediction (computed in parallel with subtraction)
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire potential_overflow = (A_sign ^ B_sign) & (A_sign ^ (A < B));

    // Segment the 64-bit operation into 4x16-bit blocks
    wire [15:0] res [0:3];
    wire [3:0] carry_out;
    
    // First segment (LSB) - simple subtractor
    assign {carry_out[0], res[0]} = A[15:0] - B[15:0];
    
    // Subsequent segments - carry-select subtractors
    genvar i;
    generate
        for (i=1; i<4; i=i+1) begin : SEGMENTS
            // Compute both possible results (carry=0 and carry=1)
            wire [16:0] res_c0 = A[i*16 +: 16] - B[i*16 +: 16];
            wire [16:0] res_c1 = A[i*16 +: 16] - B[i*16 +: 16] - 1;
            
            // Select correct result based on previous carry
            assign {carry_out[i], res[i]} = carry_out[i-1] ? res_c1 : res_c0;
        end
    endgenerate

    // Combine segment results
    assign result = {res[3], res[2], res[1], res[0]};

    // Final overflow determination
    assign overflow = potential_overflow & (A_sign ^ result[63]);

endmodule