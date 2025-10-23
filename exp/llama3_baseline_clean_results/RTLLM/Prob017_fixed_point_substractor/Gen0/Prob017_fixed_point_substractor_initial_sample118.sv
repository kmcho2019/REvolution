module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
)(
    input  wire [N-1:0] a,  // First input operand
    input  wire [N-1:0] b,  // Second input operand
    output wire [N-1:0] c   // Output result
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign
        res = a - b;
    end else if (a[N-1] == 0) begin  // a is positive, b is negative
        if (a >= -b) begin
            res = a + (~b + 1);  // Add absolute values, result is positive
        end else begin
            res = (~b + 1) - a;  // Result is negative
            res = ~(res - 1);  // Two's complement
        end
    end else begin  // a is negative, b is positive
        if (-a >= b) begin
            res = (~a + 1) + b;  // Add absolute values, result is negative
            res = ~(res - 1);  // Two's complement
        end else begin
            res = b - (~a + 1);  // Result is positive
        end
    end

    // Handling zero
    if (res == 0) begin
        res[N-1] = 0;  // Set sign bit to 0
    end
end

assign c = res;

endmodule