module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (default 8)
    parameter N = 16   // Total number of bits (default 16)
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

// Validate parameters
initial begin
    if (Q >= N) begin
        $error("Q must be less than N");
        $finish;
    end
end

// Internal signals
reg [N-1:0] a_magnitude;
reg [N-1:0] b_magnitude;
reg [N-1:0] sum;
reg [N-1:0] abs_diff;
reg result_sign;

always @(*) begin
    // Extract magnitudes (sign-extended for correct subtraction)
    a_magnitude = a[N-1] ? -a : a;
    b_magnitude = b[N-1] ? -b : b;
    
    // Calculate sum and absolute difference
    sum = a_magnitude + b_magnitude;
    abs_diff = (a_magnitude > b_magnitude) ? 
               (a_magnitude - b_magnitude) : 
               (b_magnitude - a_magnitude);
    
    // Determine operation type and result
    if (a[N-1] == b[N-1]) begin
        // Addition case - same signs
        result_sign = a[N-1];
        
        // Handle overflow
        if (sum[N-1] != result_sign) begin
            // Overflow occurred - saturate to maximum magnitude
            c[N-1] = result_sign;
            c[N-2:0] = {(N-1){1'b1}};
        end else begin
            // No overflow
            c = {result_sign, sum[N-2:0]};
        end
    end
    else begin
        // Subtraction case - different signs
        if (a_magnitude > b_magnitude) begin
            c = {a[N-1], abs_diff[N-2:0]};
        end
        else if (b_magnitude > a_magnitude) begin
            c = {b[N-1], abs_diff[N-2:0]};
        end
        else begin
            c = {N{1'b0}};  // Zero result
        end
    end
end

endmodule