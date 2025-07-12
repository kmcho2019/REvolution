module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [1:0] counter;

    // Fields
    reg a_sign, b_sign, z_sign;
    reg signed [8:0] a_exp, b_exp, z_exp; // signed 9-bit to hold exponent arithmetic
    reg [23:0] a_mantissa, b_mantissa, z_mantissa; // mantissa with leading 1 or 0 for denormals

    reg [47:0] product;

    // Rounding bits
    reg guard_bit, sticky_bit;

    // Special case flags
    reg a_nan, b_nan, a_inf, b_inf, a_zero, b_zero;
    reg nan_flag, inf_flag, zero_flag, inf_zero_conflict;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 32'b0;

            a_sign <= 0; b_sign <= 0; z_sign <= 0;
            a_exp <= 0; b_exp <= 0; z_exp <= 0;
            a_mantissa <= 0; b_mantissa <= 0; z_mantissa <= 0;
            product <= 0;
            guard_bit <= 0; sticky_bit <= 0;
            a_nan <= 0; b_nan <= 0; a_inf <= 0; b_inf <= 0; a_zero <= 0; b_zero <= 0;
            nan_flag <= 0; inf_flag <= 0; zero_flag <= 0; inf_zero_conflict <= 0;
        end else begin
            case(counter)
                2'd0: begin
                    // Extract signs
                    a_sign <= a[31];
                    b_sign <= b[31];

                    // Extract exponents as signed values
                    a_exp <= {1'b0, a[30:23]} - 9'd127;
                    b_exp <= {1'b0, b[30:23]} - 9'd127;

                    // Extract mantissas with hidden bit
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Detect special cases
                    a_nan <= (a[30:23] == 8'hFF) && (|a[22:0]);
                    b_nan <= (b[30:23] == 8'hFF) && (|b[22:0]);
                    a_inf <= (a[30:23] == 8'hFF) && (~|a[22:0]);
                    b_inf <= (b[30:23] == 8'hFF) && (~|b[22:0]);
                    a_zero <= (a[30:23] == 8'd0) && (~|a[22:0]);
                    b_zero <= (b[30:23] == 8'd0) && (~|b[22:0]);

                    // Special cases combination
                    inf_zero_conflict <= (a_inf && b_zero) || (b_inf && a_zero);
                    nan_flag <= a_nan || b_nan || inf_zero_conflict;
                    inf_flag <= (a_inf || b_inf) && ~inf_zero_conflict && ~nan_flag;
                    zero_flag <= (a_zero || b_zero) && ~nan_flag && ~inf_flag;

                    // Multiply mantissas (24x24)
                    product <= a_mantissa * b_mantissa;

                    // Compute sign
                    z_sign <= a_sign ^ b_sign;

                    // Add exponents
                    z_exp <= a_exp + b_exp;

                    counter <= 1;
                end
                2'd1: begin
                    // Normalize product
                    if (product[47]) begin
                        // MSB=1, shift right 1: mantissa bits [47:24], exponent +1
                        z_mantissa <= product[47:24];
                        z_exp <= z_exp + 1;
                        guard_bit <= product[23];
                        // sticky bit: OR of all bits below guard bit
                        sticky_bit <= |product[22:0];
                    end else begin
                        // MSB=0, take bits [46:23], exponent unchanged
                        z_mantissa <= product[46:23];
                        guard_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end

                    // Round to nearest even
                    // round increment if guard_bit=1 and (sticky_bit=1 or LSB mantissa=1)
                    if (guard_bit && (sticky_bit || z_mantissa[0])) begin
                        {z_exp, z_mantissa} <= {z_exp, z_mantissa} + 1;
                    end

                    // Check for mantissa overflow after rounding
                    if (z_mantissa[23]) begin
                        z_mantissa <= z_mantissa >> 1;
                        z_exp <= z_exp + 1;
                    end

                    // Final output assembly and special cases
                    if (nan_flag) begin
                        // Quiet NaN: sign=0, exp=0xFF, mantissa MSB=1 (quiet bit), rest zero
                        z <= {1'b0, 8'hFF, 23'h400000};
                    end else if (inf_flag) begin
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (zero_flag) begin
                        z <= {z_sign, 31'd0};
                    end else if (z_exp >= 128) begin
                        // Overflow to infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (z_exp <= -127) begin
                        // Underflow to zero (no denormals)
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal number
                        z <= {z_sign, (z_exp + 9'd127)[7:0], z_mantissa[22:0]};
                    end

                    counter <= 0;
                end
                default: counter <= 0;
            endcase
        end
    end

endmodule