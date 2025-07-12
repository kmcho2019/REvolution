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
    
    // Magnitude comparison
    assign a_larger = (a_mag > b_mag);
    
    // Addition path (when signs are equal)
    assign sum_result = {a_sign, a_mag + b_mag};
    
    // Subtraction path (when signs differ)
    assign diff_result = (a_larger) ? 
                        {a_sign, a_mag - b_mag} : 
                        {b_sign, b_mag - a_mag};
    
    // Result selection with overflow clamping
    always @(*) begin
        if (signs_equal) begin
            // Check for addition overflow
            if (&a_mag[N-2:N-Q-1] && &b_mag[N-2:N-Q-1]) begin
                c = {a_sign, {(N-1){1'b1}}};  // Clamp to max magnitude
            end else begin
                c = sum_result;
            end
        end else begin
            // Subtraction can't overflow in magnitude
            c = diff_result;
        end
        
        // Special case: zero result (always positive)
        if (c[N-2:0] == 0) begin
            c[N-1] = 1'b0;
        end
    end

endmodule