module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32  // Total number of bits, including integer and fractional parts
)(
    input   [N-1:0] a, // First N-bit fixed-point input operand
    input   [N-1:0] b, // Second N-bit fixed-point input operand
    output  [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the sign of the operands
    if (a[N-1] == b[N-1]) begin // Same sign
        // Absolute value addition
        res = a + b;
    end else begin
        // Absolute value subtraction
        if (a[N-1] == 1'b0) begin // a is positive, b is negative
            if (a >= (~b + 1'b1)) begin // a is larger
                res = a - (~b + 1'b1); // a - (-b) = a + b
            end else begin
                res = (~b + 1'b1) - a; // -b - a = -(a + b)
                res = ~res + 1'b1; // Two's complement
            end
        end else begin // a is negative, b is positive
            if ((~a + 1'b1) >= b) begin // -a is larger
                res = (~a + 1'b1) - b; // -a - b = -(a + b)
                res = ~res + 1'b1; // Two's complement
            end else begin
                res = b - (~a + 1'b1); // b - (-a) = b + a
            end
        end
    end

    // Handle overflow by truncating the result to N bits
    if (res[N] == 1'b1) begin // Overflow
        if (res[N-1] == 1'b0) begin // Positive overflow
            c = {1'b0, {N-1{1'b1}}}; // Saturate at maximum positive value
        end else begin // Negative overflow
            c = {1'b1, {N-1{1'b0}}}; // Saturate at minimum negative value
        end
    end else begin
        c = res;
    end
end

endmodule