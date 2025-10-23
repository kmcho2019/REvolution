module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input   [N-1:0] a, // First N-bit fixed-point input operand
    input   [N-1:0] b, // Second N-bit fixed-point input operand
    output  [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res; // N-bit register used to store the result of the subtraction operation

always @(*) begin
    // Same sign subtraction
    if (a[N-1] == b[N-1]) begin
        res = a - b;
    end
    // Different sign subtraction
    else begin
        // If a is positive and b is negative, or vice versa
        if (a[N-1] == 1'b0) begin // a is positive
            if (a >= (~b + 1)) begin // a is greater than b
                res = a + (~b + 1); // Add absolute values and make result positive
            end else begin
                res = (~b + 1) - a; // Add absolute values and make result negative
                res = ~res + 1; // Two's complement
            end
        end else begin // a is negative
            if ((~a + 1) >= b) begin // a is greater than b
                res = (~a + 1) + b; // Add absolute values and make result negative
                res = ~res + 1; // Two's complement
            end else begin
                res = b - (~a + 1); // Add absolute values and make result positive
            end
        end
    end
    
    // Explicitly handle the case where the result is zero
    if (res == 0) begin
        c[N-1] = 1'b0; // Set sign bit to 0
        c[N-2:0] = {N-1{1'b0}}; // Set all other bits to 0
    end else begin
        c = res;
    end
end

endmodule