module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input   [N-1:0] a, // First N-bit fixed-point input operand
    input   [N-1:0] b, // Second N-bit fixed-point input operand
    output  [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res; // N-bit register to store the result of the subtraction operation

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign subtraction
        res = a - b;
    end else begin // Different sign subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin // a is positive, b is negative
            res = a + (~b + 1'b1); // Add absolute values, considering two's complement
        end else begin // a is negative, b is positive
            res = (~a + 1'b1) + b; // Add absolute values, considering two's complement
        end
    end
    
    if (res == 0) begin // Handle zero result
        c = {N{1'b0}}; // Explicitly set all bits to 0
    end else begin
        c = res; // Assign result to output
    end
end

endmodule