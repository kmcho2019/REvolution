module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32 // Total number of bits, including integer and fractional parts
) (
    input [N-1:0] a, // First N-bit fixed-point input operand
    input [N-1:0] b, // Second N-bit fixed-point input operand
    output reg [N-1:0] c // N-bit output representing the result of the fixed-point addition
);

always @(*) begin
    reg [N-1:0] temp; // Temporary register for result
    reg sign; // Sign bit determination

    // Determine sign of result based on input signs
    sign = (a[N-1] == b[N-1])? a[N-1] : (a >= b)? 1'b0 : 1'b1;

    // Perform absolute value addition or subtraction based on signs
    if (a[N-1] == b[N-1]) begin // Same sign
        temp = a + b;
    end else begin // Different signs
        if (a >= b) begin
            temp = a - b;
        end else begin
            temp = b - a;
        end
    end

    // Check for overflow and adjust MSB if necessary
    if (temp[N-1]!= sign) begin
        c = (sign == 1'b1)? {1'b1, {N-1{1'b0}}} : {1'b0, {N-1{1'b0}}};
    end else begin
        c = temp;
    end
end

endmodule