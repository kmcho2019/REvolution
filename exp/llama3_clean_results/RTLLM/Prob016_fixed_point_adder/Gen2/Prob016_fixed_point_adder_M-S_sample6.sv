module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16   // Total number of bits
)(
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  wire [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    if (a[N-1] == b[N-1]) begin
        // If the signs are the same, perform addition
        res = a + b;
    end else begin
        // If the signs are different, perform subtraction
        if (a > b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end
    
    // Check for overflow and adjust the result if necessary
    if (res >= {1'b1, {N-1{1'b0}}}) begin
        // If the result is greater than or equal to the maximum N-bit value, set it to the maximum value
        res = {1'b1, {N-1{1'b0}}};
    end else if (res < {N{1'b0}}) begin
        // If the result is less than zero, set it to zero
        res = {N{1'b0}};
    end
end

assign c = res;

endmodule