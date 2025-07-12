module fixed_point_subtractor #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)
(
    input   [N-1:0] a, // First N-bit fixed-point input operand
    input   [N-1:0] b, // Second N-bit fixed-point input operand
    output  [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res; // N-bit register used to store the result of the subtraction operation

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign subtraction
        res = a - b;
    end else begin // Different sign subtraction
        if (a[N-1] == 0) begin // a is positive, b is negative
            res = a + (~b + 1); // Add absolute values and handle sign
        end else begin // a is negative, b is positive
            res = (~a + 1) + b; // Add absolute values and handle sign
        end
    end

    // Handle zero result
    if (res == 0) begin
        c = 0;
    end else begin
        c = res;
    end
end

endmodule