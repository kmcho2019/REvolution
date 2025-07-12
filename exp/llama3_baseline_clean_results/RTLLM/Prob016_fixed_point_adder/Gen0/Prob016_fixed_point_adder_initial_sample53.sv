module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the sign of the inputs
    if (a[N-1] == b[N-1]) begin  // Both have the same sign
        // Perform absolute value addition
        res = a + b;
    end else begin  // Different signs, perform absolute value subtraction
        if (a[N-1] == 1 && b[N-1] == 0) begin  // a is negative, b is positive
            // Check if a is greater than b (in absolute value)
            if (a > b) begin
                res = a - b;  // Result is negative, adjust MSB
            end else begin
                res = b - a;  // Result is positive, adjust MSB if necessary
                if (res == 0) begin
                    res = 0;
                end else begin
                    // The result should be positive, but we need to handle the case where the subtraction result is negative
                    // due to the two's complement representation.
                    if (res[N-1] == 1) begin
                        // If the result is negative, we have an underflow, and we should set the result to the minimum value
                        // that can be represented by N bits.
                        res = {N{1'b0}};
                    end
                end
            end
        end else if (a[N-1] == 0 && b[N-1] == 1) begin  // a is positive, b is negative
            // Check if a is greater than b (in absolute value)
            if (a > (b[N-1:0] ^ {N{1'b1}} + 1'b1)) begin
                res = a + (b[N-1:0] ^ {N{1'b1}} + 1'b1);  // Result is positive
            end else begin
                res = (b[N-1:0] ^ {N{1'b1}} + 1'b1) - a;  // Result is negative, adjust MSB
                // Handle underflow
                if (res == 0) begin
                    res = 0;
                end else if (res[N-1] == 0) begin
                    // If the result is positive, we have an underflow, and we should set the result to the minimum value
                    // that can be represented by N bits.
                    res = {N{1'b0}};
                end
            end
        end
    end
    
    // Ensure the result fits within the N-bit range
    if (res[N-1] == 1) begin
        // If the result is negative, check for underflow
        if (res == {N{1'b1}}) begin
            res = {N{1'b1}};
        end
    end else begin
        // If the result is positive, check for overflow
        if (res == {N{1'b1}}) begin
            res = {N{1'b1}};
        end
    end
end

assign c = res;

endmodule