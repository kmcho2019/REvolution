module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

// Internal register to store the result
reg [N-1:0] res;

// Always block to calculate the result based on the signs of a and b
always @(*) begin
    if (a[N-1] == b[N-1]) begin
        // Same sign subtraction
        res = a - b;
    end else if (a[N-1] == 0 && b[N-1] == 1) begin
        // a is positive, b is negative
        res = a + (~b + 1);
    end else begin
        // a is negative, b is positive
        res = (~a + 1) + b;
    end
    
    // Handle zero result
    if (res == 0) begin
        res = 0;
    end
end

// Assign the result to output port c
assign c = res;

endmodule