module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32  // Total number of bits, including integer and fractional parts
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same signs, perform absolute value addition
        res = a + b;
        if (res >= (1 << N)) begin // Overflow handling
            res = {1'b1, {N-1{1'b1}}}; // Saturate at maximum value
        end
    end else begin // Different signs, perform absolute value subtraction
        if (a[N-1] == 1'b0) begin // a is positive, b is negative
            if (a >= (~b + 1)) begin // a is greater than b
                res = a - (~b + 1); // Perform subtraction
            end else begin
                res = (~b + 1) - a; // Perform subtraction with sign extension
                res = {~res[N-1], res[N-2:0]} + 1; // Two's complement
            end
        end else begin // a is negative, b is positive
            if ((~a + 1) >= b) begin // a is greater than b (in absolute value)
                res = (~a + 1) - b; // Perform subtraction with sign extension
                res = {~res[N-1], res[N-2:0]} + 1; // Two's complement
            end else begin
                res = b - (~a + 1); // Perform subtraction
            end
        end
    end
end

assign c = res;

endmodule