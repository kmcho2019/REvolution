module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
)(
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  wire [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

always @(a or b) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        res = a - b;
    end else begin  // Different sign subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a is positive, b is negative
            if (a > (~b + 1'b1)) begin  // a is greater than the absolute value of b
                res = a + (~b + 1'b1);
            end else begin
                res = (~b + 1'b1) - a;
                res[N-1] = 1'b1;  // Set the sign bit to 1 (negative)
            end
        end else begin  // a is negative, b is positive
            if ((~a + 1'b1) > b) begin  // The absolute value of a is greater than b
                res = (~a + 1'b1) + (~b + 1'b1);
                res[N-1] = 1'b1;  // Set the sign bit to 1 (negative)
            end else begin
                res = b - (~a + 1'b1);
            end
        end
    end
    
    // Handle the edge case where the result is zero
    if (res == {N{1'b0}} || res == {N{1'b1}}) begin
        res[N-1] = 1'b0;  // Set the sign bit to 0
    end
end

assign c = res;  // Assign the result to the output port

endmodule