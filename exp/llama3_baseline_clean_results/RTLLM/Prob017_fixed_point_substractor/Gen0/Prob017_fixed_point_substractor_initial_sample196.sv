module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  wire [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        if (a >= b) begin
            res = a - b;
        end else begin
            res = b - a;
            res[N-1] = 1'b1;  // Set the sign bit if a < b
        end
    end else begin  // Different sign subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a is positive, b is negative
            if (a >= (~b + 1)) begin
                res = a - (~b + 1);
            end else begin
                res = (~b + 1) - a;
                res[N-1] = 1'b1;  // Set the sign bit if a < b
            end
        end else begin  // a is negative, b is positive
            if ((~a + 1) >= b) begin
                res = (~a + 1) - b;
                res[N-1] = 1'b1;  // Set the sign bit if a < b
            end else begin
                res = b - (~a + 1);
            end
        end
    end
    
    // Handle the case where the result is zero
    if (res == {N{1'b0}} || res == {1'b0, {N-1{1'b1}}}) begin
        res[N-1] = 1'b0;  // Explicitly set the sign bit to 0 for zero result
    end
end

assign c = res;

endmodule