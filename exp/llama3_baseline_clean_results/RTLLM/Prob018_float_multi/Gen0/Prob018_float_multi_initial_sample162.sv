module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [9:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialization
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        a_mantissa <= 0;
        b_mantissa <= 0;
        z_mantissa <= 0;
        a_exponent <= 0;
        b_exponent <= 0;
        z_exponent <= 0;
        a_sign <= 0;
        b_sign <= 0;
        z_sign <= 0;
        product <= 0;
        guard_bit <= 0;
        round_bit <= 0;
        sticky <= 0;
        z <= 0;
    end else begin
        // Input processing
        if (counter == 0) begin
            a_sign <= a[31];
            a_exponent <= a[30:23];
            a_mantissa <= a[22:0];
            b_sign <= b[31];
            b_exponent <= b[30:23];
            b_mantissa <= b[22:0];
            counter <= 1;
        end

        // Special cases handling
        else if (counter == 1) begin
            if ((a_exponent == 10'd255 && a_mantissa != 0) || (b_exponent == 10'd255 && b_mantissa != 0)) begin
                // NaN or infinity
                z <= (a_exponent == 10'd255 && a_mantissa != 0) ? a : b;
                counter <= 0;
            end else if (a_exponent == 10'd255 || b_exponent == 10'd255) begin
                // Infinity
                z_sign <= a_sign || b_sign;
                z_exponent <= 10'd255;
                z_mantissa <= 0;
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 0;
            end else begin
                counter <= 2;
            end
        end

        // Normalization
        else if (counter == 2) begin
            if (a_exponent == 0 && a_mantissa != 0) begin
                // Denormalized number
                a_exponent <= 1;
                a_mantissa <= a_mantissa << 1;
            end
            if (b_exponent == 0 && b_mantissa != 0) begin
                // Denormalized number
                b_exponent <= 1;
                b_mantissa <= b_mantissa << 1;
            end
            counter <= 3;
        end

        // Multiplication
        else if (counter == 3) begin
            product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
            z_sign <= a_sign ^ b_sign;
            z_exponent <= a_exponent + b_exponent - 10'd127;
            counter <= 4;
        end

        // Rounding and adjustment
        else if (counter == 4) begin
            // Rounding
            guard_bit <= product[47];
            round_bit <= product[46];
            sticky <= product[45:0] != 0;
            if (guard_bit && (round_bit || sticky)) begin
                product <= product + 1;
            end

            // Exponent adjustment
            if (product[49]) begin
                z_exponent <= z_exponent + 1;
                product <= product >> 1;
            end

            counter <= 5;
        end

        // Output generation
        else if (counter == 5) begin
            z_mantissa <= product[48:25];
            if (z_exponent > 10'd254) begin
                // Overflow
                z_exponent <= 10'd255;
                z_mantissa <= 0;
            end else if (z_exponent < 1) begin
                // Underflow
                z_exponent <= 0;
                z_mantissa <= 0;
            end
            z <= {z_sign, z_exponent, z_mantissa};
            counter <= 0;
        end
    end
end

endmodule