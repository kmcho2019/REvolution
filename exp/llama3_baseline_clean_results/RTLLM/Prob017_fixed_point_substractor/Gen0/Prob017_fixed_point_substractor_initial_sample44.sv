module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
)(
    input   wire [N-1:0] a,  // First input operand
    input   wire [N-1:0] b,  // Second input operand
    output  wire [N-1:0] c   // Result of subtraction
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Determine the signs of the input operands
    if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin
        // Both operands are positive, perform subtraction
        res = a - b;
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin
        // Both operands are negative, perform subtraction
        res = a - b;
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
        // a is positive, b is negative, perform addition
        res = a + (~b + 1'b1);
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin
        // a is negative, b is positive, perform addition
        res = (~a + 1'b1) + b;
    end
    
    // Handle zero result
    if (res == 0) begin
        c = 0;
    end else begin
        c = res;
    end
end

endmodule