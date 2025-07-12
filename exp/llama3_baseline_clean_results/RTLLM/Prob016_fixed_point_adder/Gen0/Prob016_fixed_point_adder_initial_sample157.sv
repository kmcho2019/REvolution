module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register to store the result of the addition or subtraction

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign
        // Add absolute values
        res = a + b;
        // Check for overflow
        if (res >= (1 << N)) begin
            res = {1'b1, {N-1{1'b0}}};  // Saturate to max value if overflow
        end
    end else begin  // Different signs
        if (a[N-1] == 1'b0) begin  // a is positive
            if (a > ~b + 1) begin  // a is greater
                res = a - (~b + 1);  // Subtract b from a
            end else begin
                res = (~b + 1) - a;  // Subtract a from b
                // Set MSB to indicate negative result
                if (res!= 0) begin
                    res = ~res + 1;  // Two's complement
                end
            end
        end else begin  // b is positive
            if (~a + 1 > b) begin  // a is greater (in absolute value)
                res = (~a + 1) - b;  // Subtract b from a
                // Set MSB to indicate negative result
                if (res!= 0) begin
                    res = ~res + 1;  // Two's complement
                end
            end else begin
                res = b - (~a + 1);  // Subtract a from b
            end
        end
    end
end

assign c = res;  // Assign result to output

endmodule