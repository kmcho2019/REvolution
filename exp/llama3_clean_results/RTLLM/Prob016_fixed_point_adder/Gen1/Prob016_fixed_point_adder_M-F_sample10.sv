module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16   // Total number of bits
)(
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  wire [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

wire [N-1:0] a_abs, b_abs;  // Absolute values of a and b
wire [N-1:0] max_val, min_val;  // Maximum and minimum N-bit values

assign max_val = {'b, {N-1{1'b0}}};  // Maximum positive value
assign min_val = {N{1'b1}};  // Minimum negative value (two's complement)

// Calculate absolute values of a and b
always @(*) begin
    if (a[N-1] == 1'b1) begin
        a_abs = -a;  // Two's complement
    end else begin
        a_abs = a;
    end
    
    if (b[N-1] == 1'b1) begin
        b_abs = -b;  // Two's complement
    end else begin
        b_abs = b;
    end
end

// Perform addition or subtraction based on the signs of a and b
always @(*) begin
    if (a[N-1] == b[N-1]) begin
        // If the signs are the same, perform addition
        res = a + b;
    end else begin
        // If the signs are different, perform subtraction
        if (a_abs > b_abs) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end
    
    // Check for overflow and adjust the result if necessary
    if (res[N-1] == 1'b1) begin
        // If the result is negative, check if it fits within the N-bit range
        if (res < -max_val) begin
            // If the result is less than the minimum N-bit value, set it to the minimum value
            res = min_val;
        end
    end else begin
        // If the result is positive, check if it fits within the N-bit range
        if (res >= max_val) begin
            // If the result is greater than or equal to the maximum N-bit value, set it to the maximum value
            res = max_val - 1'b1;
        end
    end
end

assign c = res;

endmodule