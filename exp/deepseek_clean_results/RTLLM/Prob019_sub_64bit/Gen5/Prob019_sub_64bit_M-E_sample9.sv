module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output reg signed [63:0] result,
    output reg overflow
);

// Internal signals for segmented subtraction
wire [15:0] diff0, diff1, diff2, diff3;
wire carry0, carry1, carry2, carry3;
wire ovf_pred;

// Early overflow prediction (only examines MSBs)
assign ovf_pred = ((~A[63] & B[63]) | (A[63] & ~B[63]);

// Segment 0 (LSB)
assign {carry0, diff0} = A[15:0] - B[15:0];

// Segment 1
assign {carry1, diff1} = A[31:16] - B[31:16] - carry0;

// Segment 2
assign {carry2, diff2} = A[47:32] - B[47:32] - carry1;

// Segment 3 (MSB)
assign {carry3, diff3} = A[63:48] - B[63:48] - carry2;

// Final result assembly
always @(*) begin
    result = {diff3, diff2, diff1, diff0};
    
    // Overflow detection (uses early prediction and final sign)
    overflow = ovf_pred & 
              ((~A[63] & B[63] & result[63]) |  // Positive overflow
               (A[63] & ~B[63] & ~result[63])); // Negative overflow
end

endmodule