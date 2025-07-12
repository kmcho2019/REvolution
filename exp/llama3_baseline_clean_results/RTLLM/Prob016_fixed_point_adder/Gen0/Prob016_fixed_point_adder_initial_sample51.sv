module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input [N-1:0] a,  // First N-bit fixed-point input operand
    input [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // If MSBs are the same
        res = a + b;  // Add absolute values
        if (res >= (1 << N)) begin  // Check for overflow
            res = {1'b1, {N-1{1'b0}}};  // Set to max value if overflow
        end
    end else begin  // If MSBs are different
        if (a[N-1] == 1'b1) begin  // a is negative
            if (b[N-1] == 1'b0) begin  // b is positive
                if (a < b) begin  // |a| < |b|
                    res = b - a;  // b - a, result is positive
                end else begin  // |a| >= |b|
                    res = a - b;  // a - b, result is negative
                    res = ~res + 1;  // Convert to 2's complement
                end
            end else begin  // Both a and b are negative
                if (a < b) begin  // |a| < |b|
                    res = b - a;  // b - a, result is negative
                    res = ~res + 1;  // Convert to 2's complement
                end else begin  // |a| >= |b|
                    res = a - b;  // a - b, result is negative
                    res = ~res + 1;  // Convert to 2's complement
                end
            end
        end else begin  // a is positive
            if (b[N-1] == 1'b1) begin  // b is negative
                if (a < b) begin  // |a| < |b|
                    res = b - a;  // b - a, result is negative
                    res = ~res + 1;  // Convert to 2's complement
                end else begin  // |a| >= |b|
                    res = a - b;  // a - b, result is positive
                end
            end else begin  // Both a and b are positive
                if (a < b) begin  // |a| < |b|
                    res = b - a;  // b - a, result is positive
                end else begin  // |a| >= |b|
                    res = a - b;  // a - b, result is positive
                end
            end
        end
    end
    c = res;  // Assign result to output
end

endmodule