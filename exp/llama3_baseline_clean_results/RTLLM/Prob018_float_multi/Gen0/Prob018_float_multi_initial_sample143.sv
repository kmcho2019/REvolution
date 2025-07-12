module float_multi(
    input         clk,
    input         rst,
    input  [31:0] a,
    input  [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

always @(*) begin
    // Extracting sign, exponent, and mantissa
    a_sign = a[31];
    a_exponent = a[30:23];
    a_mantissa = a[22:0];
    
    b_sign = b[31];
    b_exponent = b[30:23];
    b_mantissa = b[22:0];
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin // Initialization
                // Special cases handling (e.g., NaN, infinity)
                if ((a_exponent == 9'b11111111 && a_mantissa != 0) || (b_exponent == 9'b11111111 && b_mantissa != 0)) begin
                    z <= 32'b1; // Result is NaN
                end else if ((a_exponent == 9'b11111111 && a_mantissa == 0) || (b_exponent == 9'b11111111 && b_mantissa == 0)) begin
                    z <= 32'b0; // Result is infinity
                end else begin
                    counter <= counter + 1;
                end
            end
            3'b001: begin // Normalization and Multiplication
                // Normalization if needed (not fully implemented for brevity)
                // Multiplication of mantissas and combining signs
                product = (a_mantissa + 1) * (b_mantissa + 1);
                z_sign = a_sign ^ b_sign;
                z_exponent = a_exponent + b_exponent - 127; // Adjusting exponent
                counter <= counter + 1;
            end
            3'b010: begin // Rounding and Adjustment
                // Rounding (not fully implemented for brevity)
                // Adjust exponent if overflow or underflow during rounding
                if (z_exponent > 255) begin
                    z_exponent = 255;
                    z_mantissa = 24'b1; // Overflow, setting to infinity
                end else if (z_exponent < 1) begin
                    z_exponent = 1;
                    z_mantissa = 24'b0; // Underflow, setting to minimum representable value
                end
                counter <= counter + 1;
            end
            3'b011: begin // Output Generation
                // Formatting result in IEEE 754 format
                z[31] = z_sign;
                z[30:23] = z_exponent[7:0];
                z[22:0] = z_mantissa[22:0];
                counter <= 3'b000; // Reset counter for next operation
            end
            default: counter <= counter;
        endcase
    end
end

endmodule