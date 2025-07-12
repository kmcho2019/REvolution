module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent; // Using 9 bits for correct representation
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin // Initialization and Input Processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b001;
            end
            3'b001: begin // Multiplication and Exponent Calculation
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_exponent <= a_exponent + b_exponent - 127; // Adjusting for bias
                counter <= 3'b010;
            end
            3'b010: begin // Rounding and Adjustment
                z_mantissa <= product[47:24]; // Simplified rounding, no guard or sticky bits
                if (product[23:0] != 0) begin // Simplified rounding logic
                    z_mantissa <= z_mantissa + 1;
                end
                if (z_exponent > 255) begin // Overflow
                    z_exponent <= 255;
                    z_mantissa <= 0;
                end else if (z_exponent < -126) begin // Underflow
                    z_exponent <= -126;
                    z_mantissa <= 0;
                end
                counter <= 3'b011;
            end
            3'b011: begin // Output Generation
                z <= {z_sign, z_exponent[7:0], z_mantissa};
                counter <= 3'b000;
            end
            default: counter <= 3'b000;
        endcase
    end
end

endmodule