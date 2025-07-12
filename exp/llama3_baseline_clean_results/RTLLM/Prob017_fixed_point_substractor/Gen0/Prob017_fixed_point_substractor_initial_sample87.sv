module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
) (
    input   [N-1:0] a, // First input operand
    input   [N-1:0] b, // Second input operand
    output  [N-1:0] c  // Result of subtraction
);

reg [N-1:0] res; // Internal register to store result

always @(*) begin
    // Determine signs of inputs
    if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin // Both positive
        if (a >= b) begin
            res = a - b;
        end else begin
            res = b - a;
            res[N-1] = 1'b1; // Set sign bit if a is smaller
        end
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin // Both negative
        if (a >= b) begin
            res = a - b;
        end else begin
            res = b - a;
            res[N-1] = 1'b0; // Clear sign bit if a is smaller
        end
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin // a positive, b negative
        res = a + (~b + 1'b1); // Add absolute values, considering two's complement
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin // a negative, b positive
        res = (~a + 1'b1) + b; // Add absolute values, considering two's complement
    end

    // Handle zero result
    if (res == 0) begin
        res[N-1] = 1'b0; // Explicitly set sign bit to 0 for zero result
    end
end

assign c = res; // Assign result to output

endmodule