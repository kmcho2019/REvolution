module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,  // First N-bit fixed-point input operand
    input [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        res = a - b;
    end else begin  // Different sign subtraction
        if (a[N-1] == 0) begin  // a is positive and b is negative
            if (a > -b) begin
                res = a + (~b + 1);  // Add the absolute values of a and b
            end else begin
                res = (~a + 1) + b;  // Subtract a from b and take the two's complement
                res = ~res + 1;  // Take the two's complement of the result
            end
        end else begin  // a is negative and b is positive
            if (-a > b) begin
                res = (~a + 1) + (~b + 1);  // Add the absolute values of a and b
                res = ~res + 1;  // Take the two's complement of the result
            end else begin
                res = b - (~a + 1);  // Subtract a from b
            end
        end
    end

    if (res == 0) begin  // Handle zero result
        c = {1'b0, {N-1{1'b0}}};  // Set the sign bit to 0
    end else begin
        c = res;
    end
end

endmodule