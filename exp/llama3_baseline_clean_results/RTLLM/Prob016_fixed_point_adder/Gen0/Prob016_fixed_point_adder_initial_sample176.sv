module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result
);

// Internal register to store the result
reg [N-1:0] res;

// Determine the sign of the operands
wire a_sign = a[N-1];
wire b_sign = b[N-1];

// Determine if the result should be positive or negative
wire res_sign = (a_sign == b_sign) ? a_sign : (a[N-1:Q] > b[N-1:Q]) ? 1'b0 : 1'b1;

// Perform absolute value addition or subtraction
always @(*) begin
    if (a_sign == b_sign) begin
        // Absolute value addition
        res = a + b;
    end else begin
        // Absolute value subtraction
        if (a[N-1:Q] > b[N-1:Q]) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end
end

// Assign the result with the correct sign
always @(*) begin
    if (res_sign) begin
        c = {1'b1, {N-1{1'b0}}} + (~res + 1'b1);
    end else begin
        c = res;
    end
end

endmodule