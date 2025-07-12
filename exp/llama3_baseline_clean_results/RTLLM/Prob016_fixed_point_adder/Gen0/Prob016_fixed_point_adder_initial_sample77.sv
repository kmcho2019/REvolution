module fixed_point_adder #(
    parameter Q = 16,  // Number of fractional bits (precision)
    parameter N = 32   // Total number of bits
)(
    input  logic [N-1:0] a,  // First N-bit fixed-point input operand
    input  logic [N-1:0] b,  // Second N-bit fixed-point input operand
    output logic [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

logic [N-1:0] res;  // N-bit register to store the result

always @(a, b) begin
    // Check if both numbers are positive or both negative
    if (a[N-1] == b[N-1]) begin
        // Add absolute values
        res = a + b;
    end else begin
        // Determine larger absolute value
        if (a[N-1] == 0 && b[N-1] == 1) begin
            // a is positive, b is negative
            if (a > (~b + 1)) begin
                // a is larger, result is a - b and positive
                res = a + (~b + 1);
            end else begin
                // b is larger, result is b - a
                res = (~a + 1) + b;
            end
        end else if (a[N-1] == 1 && b[N-1] == 0) begin
            // a is negative, b is positive
            if (~a + 1 > b) begin
                // a is larger, result is a - b and negative
                res = (~a + 1) + (~b + 1);
            end else begin
                // b is larger, result is b - a and positive
                res = b + (~a + 1);
            end
        end
    end

    // Handle overflow by checking MSB
    if (res[N] == 1) begin
        // Overflow, truncate result to fit N-bit range
        c = {1'b0, res[N-1:1]};
    end else begin
        // No overflow, assign result directly
        c = res;
    end
end

endmodule