module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits (integer + fractional)
) (
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(a, b) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        // Perform subtraction directly
        res = a - b;
    end else begin // Different signs
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin // a positive, b negative
            // Add absolute values and determine sign based on comparison
            if (a > (~b + 1'b1)) begin
                res = a + (~b + 1'b1);
            end else begin
                res = (~a + 1'b1) + b;
                res[N-1] = 1'b1; // Set sign bit to 1 (negative)
            end
        end else begin // a negative, b positive
            // Add absolute values and determine sign based on comparison
            if ((~a + 1'b1) > b) begin
                res = (~a + 1'b1) + b;
                res[N-1] = 1'b1; // Set sign bit to 1 (negative)
            end else begin
                res = a + (~b + 1'b1);
            end
        end
    end
    
    // Handle zero result explicitly
    if (res == 0) begin
        res[N-1] = 1'b0; // Set sign bit to 0 for zero result
    end
end

assign c = res;

endmodule