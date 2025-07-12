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

always @ (posedge clk) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin // Initialization
                // Extract mantissas, exponents, and sign bits
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];

                // Check for special cases (NaN, infinity)
                if ((a_exponent == 8'hff && a_mantissa!= 0) || (b_exponent == 8'hff && b_mantissa!= 0)) begin
                    z <= 32'h7fc00000; // NaN
                end else if ((a_exponent == 8'hff && a_mantissa == 0) || (b_exponent == 8'hff && b_mantissa == 0)) begin
                    z <= 32'h7f800000; // Infinity
                end

                counter <= counter + 1;
            end
            3'b001: begin // Normalization and multiplication
                // Normalize mantissas if necessary
                if (a_exponent!= 0) begin
                    a_mantissa <= {1'b1, a_mantissa};
                    a_exponent <= a_exponent - 1;
                end
                if (b_exponent!= 0) begin
                    b_mantissa <= {1'b1, b_mantissa};
                    b_exponent <= b_exponent - 1;
                end

                // Multiply mantissas
                product <= a_mantissa * b_mantissa;

                // Adjust exponents
                z_exponent <= a_exponent + b_exponent;

                counter <= counter + 1;
            end
            3'b010: begin // Rounding and adjustment
                // Round the result
                {guard_bit, round_bit, sticky} <= product[22:20];
                if (guard_bit && (round_bit || sticky)) begin
                    product <= product + 1;
                end

                // Adjust exponent
                if (product[49]) begin
                    product <= product >> 1;
                    z_exponent <= z_exponent + 1;
                end

                counter <= counter + 1;
            end
            3'b011: begin // Output generation
                // Combine sign bits
                z_sign <= a_sign ^ b_sign;

                // Format the final result in IEEE 754 standard
                z <= {z_sign, z_exponent, product[23:0]};

                counter <= 3'b000;
            end
        endcase
    end
end

endmodule