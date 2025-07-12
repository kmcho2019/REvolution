module sub_64bit (
    input clk,            // Added clock for registration
    input signed [63:0] A,
    input signed [63:0] B,
    output reg signed [63:0] result,  // Now registered
    output reg overflow
);

    // Intermediate signals
    wire signed [63:0] result_next = A - B;
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire res_sign = result_next[63];
    
    // Simplified overflow conditions
    wire pos_overflow = ~A_sign & B_sign & res_sign;
    wire neg_overflow = A_sign & ~B_sign & ~res_sign;
    wire overflow_next = pos_overflow | neg_overflow;

    // Sequential logic for registration
    always @(posedge clk) begin
        result <= result_next;
        overflow <= overflow_next;
    end

endmodule