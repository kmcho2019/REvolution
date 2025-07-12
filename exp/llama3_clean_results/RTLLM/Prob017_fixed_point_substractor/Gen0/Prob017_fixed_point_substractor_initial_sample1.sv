module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
)(
    input   wire [N-1:0] a,  // First input operand
    input   wire [N-1:0] b,  // Second input operand
    output  wire [N-1:0] c   // Result of subtraction
);

reg [N-1:0] res;  // Internal register to store the result

always @(a or b) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        res = a - b;
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a is positive, b is negative
        if (a >= (~b + 1)) begin
            res = a + (~b + 1);  // a is greater than b, result is positive
        end else begin
            res = (~b + 1) - a;  // b is greater than a, result is negative
            res = ~res + 1;  // Convert to 2's complement
        end
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin  // a is negative, b is positive
        if ((~a + 1) >= b) begin
            res = (~a + 1) - b;  // a is greater than b, result is negative
            res = ~res + 1;  // Convert to 2's complement
        end else begin
            res = b - (~a + 1);  // b is greater than a, result is positive
        end
    end

    // Handle zero result
    if (res == 0) begin
        res = 0;  // Explicitly set sign bit to 0 for zero result
    end
end

assign c = res;  // Assign the result to the output port

endmodule