module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,  // First N-bit fixed-point input operand
    input [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

always @(a, b) begin
    // Same sign subtraction
    if ((a[N-1] == 1'b0 && b[N-1] == 1'b0) || (a[N-1] == 1'b1 && b[N-1] == 1'b1)) begin
        if (a >= b) begin
            res = a - b;
        end else begin
            res = (2**Q) - (b - a);
            res[N-1] = 1'b1;  // Set sign bit
        end
    end else begin
        // Different sign subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
            // a is positive and b is negative
            if (a >= (2**Q) - b) begin
                res = a + (2**Q) - b;
            end else begin
                res = (2**Q) - ((2**Q) - b - a);
                res[N-1] = 1'b1;  // Set sign bit
            end
        end else begin
            // a is negative and b is positive
            if ((2**Q) - a >= b) begin
                res = (2**Q) - a + (2**Q) - b;
                res[N-1] = 1'b1;  // Set sign bit
            end else begin
                res = b - ((2**Q) - a);
            end
        end
    end
    
    // Handle zero result
    if (res == 0) begin
        res[N-1] = 1'b0;  // Set sign bit to 0
    end
end

assign c = res;

endmodule