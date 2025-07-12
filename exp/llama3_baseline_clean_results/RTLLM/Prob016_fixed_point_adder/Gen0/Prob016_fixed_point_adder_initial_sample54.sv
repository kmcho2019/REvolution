module fixed_point_adder #(
    parameter Q = 16,  // Number of fractional bits (precision)
    parameter N = 32  // Total number of bits
) (
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(a, b) begin
    if (a[N-1] == b[N-1]) begin  // Same sign, perform addition
        res = a + b;
    end else begin  // Different signs, perform subtraction
        if (a[N-1] == 0) begin  // a is positive, b is negative
            if (a >= ~b + 1) begin  // a is greater than b, result is positive
                res = a + (~b + 1);
            end else begin  // b is greater than a, result is negative
                res = ~b + 1 + a;
                res = ~res + 1;  // Convert to two's complement
            end
        end else begin  // a is negative, b is positive
            if (~a + 1 >= b) begin  // a is greater than b, result is negative
                res = ~a + 1 + b;
                res = ~res + 1;  // Convert to two's complement
            end else begin  // b is greater than a, result is positive
                res = b + (~a + 1);
            end
        end
    end

    // Handle overflow
    if (res >= (1 << (N-1))) begin
        if (res[N-1]) begin  // Negative overflow
            res = {N{1'b1}};  // Set all bits to 1 (maximum negative value)
        end else begin  // Positive overflow
            res = {1'b0, {N-1{1'b1}}};  // Set all bits except MSB to 1 (maximum positive value)
        end
    end

    c = res;
end

endmodule