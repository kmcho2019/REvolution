module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Parameter validation
    initial begin
        if (Q >= N) $error("Q must be less than N");
        if (N < 2) $error("N must be at least 2");
    end

    // Sign and magnitude extraction
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire signs_equal = ~(a_sign ^ b_sign);
    
    // Magnitude comparison
    wire a_gt_b = (a[N-2:0] >= b[N-2:0]);
    
    // Arithmetic operations
    wire [N:0] sum = {a_sign, a} + {b_sign, b};
    wire [N:0] diff = a_gt_b ? {1'b0, a} - {1'b0, b} : {1'b0, b} - {1'b0, a};
    
    // Overflow and result calculation
    always @(*) begin
        if (signs_equal) begin
            // Addition case
            if (sum[N] != sum[N-1]) begin
                // Overflow - saturate to max/min
                c = {a_sign, {(N-1){~a_sign}}};
            end else begin
                c = sum[N-1:0];
            end
        end else begin
            // Subtraction case
            if (a[N-1:0] == b[N-1:0]) begin
                // Equal magnitude - result zero
                c = {N{1'b0}};
            end else begin
                // No overflow possible in subtraction
                c = {a_gt_b ? a_sign : b_sign, diff[N-2:0]};
            end
        end
    end

endmodule