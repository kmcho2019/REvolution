module float_multi(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;

    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg guard_bit, round_bit, sticky;

    // Extract mantissas, exponents, and sign bits
    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            a_mantissa <= 0;
            b_mantissa <= 0;
            a_exponent <= 0;
            b_exponent <= 0;
            a_sign <= 0;
            b_sign <= 0;
        end else if (counter == 0) begin
            counter <= counter + 1;
            a_mantissa <= a[22:0];
            b_mantissa <= b[22:0];
            a_exponent <= a[30:23];
            b_exponent <= b[30:23];
            a_sign <= a[31];
            b_sign <= b[31];
        end
    end

    // Handle special cases
    always @(posedge clk) begin
        if (rst) begin
            z_sign <= 0;
            z_exponent <= 0;
            z_mantissa <= 0;
        end else if (counter == 1) begin
            counter <= counter + 1;
            if ((a_exponent == 255 && a_mantissa != 0) || (b_exponent == 255 && b_mantissa != 0)) begin
                // NaN case
                z_exponent <= 255;
                z_mantissa <= 0;
                z_sign <= a_sign || b_sign;
            end else if ((a_exponent == 255 && a_mantissa == 0) || (b_exponent == 255 && b_mantissa == 0)) begin
                // Infinity case
                z_exponent <= 255;
                z_mantissa <= 0;
                z_sign <= a_sign || b_sign;
            end
        end
    end

    // Normalize mantissas if needed
    always @(posedge clk) begin
        if (rst) begin
            a_mantissa <= 0;
            b_mantissa <= 0;
        end else if (counter == 2) begin
            counter <= counter + 1;
            if (a_mantissa[23]) begin
                a_mantissa <= a_mantissa >> 1;
                a_exponent <= a_exponent + 1;
            end
            if (b_mantissa[23]) begin
                b_mantissa <= b_mantissa >> 1;
                b_exponent <= b_exponent + 1;
            end
        end
    end

    // Multiply mantissas
    always @(posedge clk) begin
        if (rst) begin
            product <= 0;
        end else if (counter == 3) begin
            counter <= counter + 1;
            product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
        end
    end

    // Round and adjust result
    always @(posedge clk) begin
        if (rst) begin
            z_mantissa <= 0;
            z_exponent <= 0;
            z_sign <= 0;
        end else if (counter == 4) begin
            counter <= counter + 1;
            if (product[49]) begin
                // Round up
                z_mantissa <= product[48:25] + 1;
                if (z_mantissa[23]) begin
                    z_mantissa <= z_mantissa >> 1;
                    z_exponent <= a_exponent + b_exponent + 1;
                end else begin
                    z_exponent <= a_exponent + b_exponent;
                end
            end else begin
                // Round down
                z_mantissa <= product[48:25];
                z_exponent <= a_exponent + b_exponent;
            end
            z_sign <= a_sign ^ b_sign;
        end
    end

    // Generate output
    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
        end else if (counter == 5) begin
            z <= {z_sign, z_exponent, z_mantissa};
        end
    end

endmodule