module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

always @(a or b) begin
    if (a[N-1] == b[N-1]) begin // Same sign subtraction
        res = a - b;
        if (res == 0) begin // Handle zero result
            res[N-1] = 0; // Set sign bit to 0
        end else begin
            res[N-1] = a[N-1]; // Preserve sign bit
        end
    end else begin // Different sign subtraction
        if (a[N-1] == 0 && b[N-1] == 1) begin // a is positive, b is negative
            if (a > (b ^ { {N-1{1}}, {N-1{0}} })) begin // a is greater than b
                res = a + (~b + 1); // Add absolute values
                res[N-1] = 0; // Set sign bit to 0
            end else begin
                res = (~a + 1) + b; // Add absolute values
                res[N-1] = 1; // Set sign bit to 1
            end
        end else begin // a is negative, b is positive
            if ((~a + 1) > b) begin // a is greater than b
                res = (~b + 1) + a; // Add absolute values
                res[N-1] = 1; // Set sign bit to 1
            end else begin
                res = b + (~a + 1); // Add absolute values
                res[N-1] = 0; // Set sign bit to 0
            end
        end
        if (res == 0) begin // Handle zero result
            res[N-1] = 0; // Set sign bit to 0
        end
    end
end

assign c = res; // Assign result to output

endmodule