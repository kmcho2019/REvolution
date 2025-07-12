module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [7:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        a_mantissa <= 24'b0;
        b_mantissa <= 24'b0;
        a_exponent <= 8'b0;
        b_exponent <= 8'b0;
        a_sign <= 1'b0;
        b_sign <= 1'b0;
        product <= 50'b0;
        guard_bit <= 1'b0;
        round_bit <= 1'b0;
        sticky <= 1'b0;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin // Input Processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= counter + 1;
            end
            3'b001: begin // Special Cases Handling
                if ((a_exponent == 8'b255 && a_mantissa != 24'b0) || (b_exponent == 8'b255 && b_mantissa != 24'b0)) begin
                    // Handle NaN
                    z <= 32'b1; // Simplified NaN handling, actual implementation should follow IEEE 754 rules
                end else if ((a_exponent == 8'b255 && a_mantissa == 24'b0) || (b_exponent == 8'b255 && b_mantissa == 24'b0)) begin
                    // Handle Infinity
                    z <= 32'b1; // Simplified Infinity handling, actual implementation should follow IEEE 754 rules
                end else begin
                    counter <= counter + 1;
                end
            end
            3'b010: begin // Normalization and Multiplication
                // Normalize mantissas (for simplicity, assume already normalized)
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                counter <= counter + 1;
            end
            3'b011: begin // Sign Combination and Exponent Adjustment
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 8'b127;
                counter <= counter + 1;
            end
            3'b100: begin // Rounding and Adjustment
                // Rounding logic (simplified)
                if (product[49:47] == 3'b100) begin
                    z_mantissa <= product[46:23] + 1;
                    if (z_mantissa == 24'b10000000) begin
                        z_mantissa <= 24'b0;
                        z_exponent <= z_exponent + 1;
                    end
                end else begin
                    z_mantissa <= product[46:23];
                end
                counter <= counter + 1;
            end
            3'b101: begin // Output Generation
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000;
            end
            default: begin
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule