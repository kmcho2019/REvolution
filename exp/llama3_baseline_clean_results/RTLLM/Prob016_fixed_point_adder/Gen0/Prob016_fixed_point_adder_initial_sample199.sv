module fixed_point_adder #(
    parameter Q = 16,  // Number of fractional bits (precision)
    parameter N = 32   // Total number of bits
) (
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same signs, perform addition
        res = a + b;
        // Ensure result's MSB matches inputs' MSBs
        if (a[N-1] == 1'b1) begin  // Negative numbers
            if (res[N-1] == 1'b0) begin  // Result is positive, handle overflow
                res = {1'b1, {N-1{1'b1}}};
            end
        end else begin  // Positive numbers
            if (res[N-1] == 1'b1) begin  // Result is negative, handle underflow
                res = {N{1'b0}};
            end
        end
    end else begin  // Different signs, perform subtraction
        if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin  // a is negative, b is positive
            if (a < b) begin  // |b| > |a|
                res = b - (a[N-1] ? -a : a);  // Subtract absolute value of a from b
                res[N-1] = 0;  // Result is positive
            end else begin  // |a| >= |b|
                res = -a - b;  // Subtract b from negative a
                res[N-1] = 1;  // Result is negative
            end
        end else begin  // a is positive, b is negative
            if (b < a) begin  // |a| > |b|
                res = a - (b[N-1] ? -b : b);  // Subtract absolute value of b from a
                res[N-1] = 0;  // Result is positive
            end else begin  // |b| >= |a|
                res = -b - a;  // Subtract a from negative b
                res[N-1] = 1;  // Result is negative
            end
        end
    end
    // Assign result to output
    c = res;
end

endmodule