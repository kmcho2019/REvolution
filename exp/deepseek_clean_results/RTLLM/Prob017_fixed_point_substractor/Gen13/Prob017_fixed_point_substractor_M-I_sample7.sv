module fixed_point_subtractor #(
    parameter Q = 16,      // Number of fractional bits
    parameter N = 32       // Total number of bits
) (
    input wire clk,        // Clock for pipelining
    input wire reset_n,    // Active-low reset
    input wire [N-1:0] a,  // First operand
    input wire [N-1:0] b,  // Second operand
    output reg [N-1:0] c,  // Result output
    output wire overflow   // Overflow flag
);

    // Parameter validation
    initial begin
        if (Q >= N) $error("Q must be less than N");
        if (N <= 1) $error("N must be greater than 1");
    end

    // Pipeline registers
    reg [N-1:0] stage1_result;
    reg stage1_zero;
    
    // Overflow detection
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire result_sign;
    wire [N-1:0] raw_result = a - b;
    
    assign result_sign = raw_result[N-1];
    assign overflow = (~a_sign & b_sign & result_sign) | 
                    (a_sign & ~b_sign & ~result_sign);

    // Clock gating for power optimization
    wire zero_detect_en = |(a ^ b);  // Only enable when inputs differ
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            stage1_result <= {N{1'b0}};
            stage1_zero <= 1'b0;
            c <= {N{1'b0}};
        end else begin
            // Stage 1: Compute result and zero detection
            stage1_result <= raw_result;
            stage1_zero <= zero_detect_en ? ~(|raw_result) : 1'b0;
            
            // Stage 2: Final output with zero handling
            c <= stage1_zero ? {N{1'b0}} : stage1_result;
        end
    end

endmodule