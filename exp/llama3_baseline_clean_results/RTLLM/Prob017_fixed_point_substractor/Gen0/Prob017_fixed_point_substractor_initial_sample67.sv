module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        res = a - b;
    end else begin  // Different sign subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a is positive, b is negative
            res = a + (~b + 1'b1);  // Add the absolute values of a and b
        end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin  // a is negative, b is positive
            res = (~a + 1'b1) + b;  // Add the absolute values of a and b
        end
    end

    if (res == 0) begin  // Handling zero
        c = {1'b0, {N-1{1'b0}}};  // Explicitly set the sign bit to 0 when the result is zero
    end else begin
        c = res;  // Assign the result to the output
    end
end

endmodule