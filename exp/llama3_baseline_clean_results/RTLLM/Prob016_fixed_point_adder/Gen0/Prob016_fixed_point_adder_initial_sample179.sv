module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result
);

reg [N-1:0] res;  // N-bit register used to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // MSBs are the same
        // Absolute value addition
        res = a + b;
        if (res >= (1 << N)) begin  // Overflow handling
            res = {1'b1, {N-1{1'b0}}};  // Saturate to maximum value
        end
    end else begin  // MSBs are different
        // Absolute value subtraction
        if (a[N-1] == 1'b0) begin  // a is positive, b is negative
            if (a >= (~b + 1)) begin
                res = a - (~b + 1);  // a - b
            end else begin
                res = (~a + 1) - b;  // b - a, with result sign bit set to 1 (negative)
            end
        end else begin  // a is negative, b is positive
            if (b >= (~a + 1)) begin
                res = b - (~a + 1);  // b - a
            end else begin
                res = (~b + 1) - a;  // a - b, with result sign bit set to 1 (negative)
            end
        end
    end
    c = res;
end

endmodule