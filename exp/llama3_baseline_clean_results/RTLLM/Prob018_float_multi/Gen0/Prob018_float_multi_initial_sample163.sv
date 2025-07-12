module float_multi (
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
        counter <= 3'd0;
        z <= 32'd0;
    end else begin
        case (counter)
            3'd0: begin
                // Extract mantissas, exponents, and sign bits from inputs
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];

                // Check for special cases (NaN, infinity)
                if ((a_exponent == 8'd255 && a_mantissa!= 23'd0) || (b_exponent == 8'd255 && b_mantissa!= 23'd0)) begin
                    // Handle NaN or infinity
                    z <= (a_exponent == 8'd255 && a_mantissa!= 23'd0)? a : b;
                end else if (a_exponent == 8'd255 || b_exponent == 8'd255) begin
                    // Handle infinity
                    z <= (a_exponent == 8'd255)? a : b;
                end else begin
                    counter <= counter + 1;
                end
            end
            3'd1: begin
                // Normalize mantissas if necessary
                if (a_exponent!= 8'd0) begin
                    a_mantissa <= {1'b1, a_mantissa};
                end
                if (b_exponent!= 8'd0) begin
                    b_mantissa <= {1'b1, b_mantissa};
                end

                // Multiply mantissas
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};

                counter <= counter + 1;
            end
            3'd2: begin
                // Calculate new exponent and sign
                z_exponent <= a_exponent + b_exponent - 8'd127;
                z_sign <= a_sign ^ b_sign;

                // Round result
                {guard_bit, round_bit, sticky} <= product[49:47];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[46:23] + 1;
                end else begin
                    z_mantissa <= product[46:23];
                end

                // Adjust exponent for overflow or underflow
                if (product[49:47] == 3'b111) begin
                    z_exponent <= z_exponent + 1;
                    z_mantissa <= z_mantissa >> 1;
                end else if (product[49:47] == 3'b000) begin
                    z_exponent <= z_exponent - 1;
                    z_mantissa <= {z_mantissa, 1'b0};
                end

                counter <= counter + 1;
            end
            3'd3: begin
                // Format result in IEEE 754 standard
                z <= {z_sign, z_exponent, z_mantissa};

                counter <= 3'd0;
            end
            default: begin
                counter <= 3'd0;
            end
        endcase
    end
end

endmodule