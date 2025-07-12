module TopModule (
    input [1:0] A,
    input [1:0] B,
    output reg z  // reg for optional registered version
);

    // Primary implementation using equality operator (optimal PPA)
    // Equivalent to: z = (~(A[0]^B[0])) & (~(A[1]^B[1]));
    always @(*) begin
        z = (A == B);
    end

    /* Alternative implementations (uncomment if needed):
    // Option 1: Registered version for better timing
    // always @(posedge clk) begin
    //     z <= (A == B);
    // end
    
    // Option 2: Explicit gate-level (same PPA as above)
    // wire bit0_equal = ~(A[0] ^ B[0]);
    // wire bit1_equal = ~(A[1] ^ B[1]);
    // assign z = bit0_equal & bit1_equal;
    */

endmodule