module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32 // Total number of bits, including integer and fractional parts
) (
    input [N-1:0] a, // First N-bit fixed-point input operand
    input [N-1:0] b, // Second N-bit fixed-point input operand
    output reg [N-1:0] c // N-bit output representing the result of the fixed-point addition
);

always @(*) begin
    reg [N:0] temp; // Temporary register to handle overflow
    if (a[N-1] == b[N-1]) begin // Same sign
        // Perform absolute value addition
        temp = a + b;
        // Check for overflow and adjust MSB if necessary
        if (temp[N]) begin
            c = {1'b1, {N-1{1'b0}}}; // Maximum negative value for N bits
        end else begin
            c = temp[N-1:0];
        end
    end else begin // Different signs
        // Perform absolute value subtraction
        if (a >= b) begin
            temp = a - b;
        end else begin
            temp = b - a;
        end
        // Check for overflow and adjust MSB if necessary
        if (temp[N]) begin
            c = {1'b1, {N-1{1'b0}}}; // Maximum negative value for N bits
        end else if (~temp[N]) begin
            c = {1'b0, temp[N-1:0]}; // Ensure sign bit is set to 0 for positive result
        end else begin
            c = temp[N-1:0];
        end
    end
end

endmodule