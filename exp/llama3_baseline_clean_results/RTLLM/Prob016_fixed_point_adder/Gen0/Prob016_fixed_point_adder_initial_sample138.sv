module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine the sign of the operands
    if (a[N-1] == b[N-1]) begin
        // Same sign, add the absolute values
        res = a + b;
    end else begin
        // Different signs, perform subtraction
        if (a[N-1] == 0) begin
            // a is positive, b is negative
            if (a >= (~b + 1)) begin
                // a is larger
                res = a - (~b + 1);
            end else begin
                // b is larger
                res = (~a + 1) - b;
                // Invert the result to maintain correct sign
                res = ~res + 1;
            end
        end else begin
            // a is negative, b is positive
            if ((~a + 1) >= b) begin
                // a is larger in absolute value
                res = (~a + 1) - b;
                // Invert the result to maintain correct sign
                res = ~res + 1;
            end else begin
                // b is larger
                res = b - (~a + 1);
            end
        end
    end
    
    // Handle overflow, maintain sign consistency
    if (res[N-1] != a[N-1] && a[N-1] == b[N-1]) begin
        // Overflow occurred, correct the sign
        if (a[N-1] == 1) begin
            res = {1'b1, {N-1{1'b1}}};
        end else begin
            res = {1'b0, {N-1{1'b0}}};
        end
    end
end

assign c = res;

endmodule