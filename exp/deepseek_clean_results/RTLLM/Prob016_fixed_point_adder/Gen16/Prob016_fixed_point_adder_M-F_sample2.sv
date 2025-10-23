module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal signals
    wire a_sign, b_sign;
    wire [N-2:0] a_mag, b_mag;
    wire signs_equal;
    wire [N-1:0] sum_result, diff_result;
    wire a_larger;
    
    // Extract sign and magnitude
    assign a_sign = a[N-1];
    assign b_sign = b[N-1];
    assign a_mag = a[N-2:0];
    assign b_mag = b[N-2:0];
    assign signs_equal = (a_sign == b_sign);
    
    // Magnitude comparison using signed arithmetic
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    assign a_larger = (a_signed > b_signed);
    
    // Addition path (when signs are equal)
    assign sum_result = a + b;
    
    // Subtraction path (when signs differ)
    assign diff_result = a_signed + b_signed;  // Handles both cases
    
    // Result selection
    always @(*) begin
        if (signs_equal) begin
            c = sum_result;
        end else begin
            c = diff_result;
        end
        
        // Special case: zero result (always positive)
        if (c[N-2:0] == 0) begin
            c[N-1] = 1'b0;
        end
    end

endmodule