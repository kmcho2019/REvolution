module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;

// Fields
reg a_sign, b_sign, z_sign;
reg [9:0] a_exp, b_exp, z_exp;        // 10 bits for intermediate exponent calculations
reg [23:0] a_man, b_man;              // mantissas with leading 1 implicit for normals
reg [49:0] product;                   // 24x24 multiplication result (max 48 bits), extra bits for rounding

// Special cases flags
reg a_is_zero, b_is_zero, a_is_inf, b_is_inf, a_is_nan, b_is_nan;
reg z_is_zero, z_is_inf, z_is_nan;

// Intermediate mantissa after rounding
reg [23:0] z_man_rounded;

// Rounding bits
reg guard, round_bit, sticky;

// Register inputs to stable internal regs for multi-cycle operation
reg [31:0] a_reg, b_reg;

always @(posedge clk) begin
    if (rst) begin
        counter <= 3'd0;
        z <= 32'd0;

        a_sign <= 0; b_sign <= 0; z_sign <= 0;
        a_exp <= 0; b_exp <= 0; z_exp <= 0;
        a_man <= 0; b_man <= 0; product <= 0;

        a_is_zero <= 0; b_is_zero <= 0; a_is_inf <= 0; b_is_inf <= 0; a_is_nan <= 0; b_is_nan <= 0;
        z_is_zero <= 0; z_is_inf <= 0; z_is_nan <= 0;

        a_reg <= 0; b_reg <= 0;
    end else begin
        case(counter)
            3'd0: begin
                // Load inputs
                a_reg <= a;
                b_reg <= b;

                // Extract sign
                a_sign <= a[31];
                b_sign <= b[31];

                // Extract exponent (biased 8 bits) extended to 10 bits
                a_exp <= {2'b00, a[30:23]};
                b_exp <= {2'b00, b[30:23]};

                // Extract mantissa and add implicit leading 1 if normalized
                a_man <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_man <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                // Special cases
                a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 0);
                b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 0);
                a_is_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
                b_is_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 0);
                a_is_nan  <= (a[30:23] == 8'hFF) && (|a[22:0]);
                b_is_nan  <= (b[30:23] == 8'hFF) && (|b[22:0]);

                counter <= 3'd1;
            end
            3'd1: begin
                // Determine output sign
                z_sign <= a_sign ^ b_sign;

                // Handle special cases precedence
                if (a_is_nan || b_is_nan) begin
                    z_is_nan <= 1'b1;
                    z_is_inf <= 1'b0;
                    z_is_zero <= 1'b0;
                end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                    // Invalid operation: inf * 0 = NaN
                    z_is_nan <= 1'b1;
                    z_is_inf <= 1'b0;
                    z_is_zero <= 1'b0;
                end else if (a_is_inf || b_is_inf) begin
                    z_is_inf <= 1'b1;
                    z_is_nan <= 1'b0;
                    z_is_zero <= 1'b0;
                end else if (a_is_zero || b_is_zero) begin
                    z_is_zero <= 1'b1;
                    z_is_nan <= 1'b0;
                    z_is_inf <= 1'b0;
                end else begin
                    z_is_nan <= 1'b0;
                    z_is_inf <= 1'b0;
                    z_is_zero <= 1'b0;

                    // Multiply mantissas: 24x24 = 48 bits (stored in lower 48 bits of product)
                    product <= a_man * b_man;

                    // Add exponents and subtract bias 127
                    // Exponents have 2 extra bits, safe to add/subtract here
                    z_exp <= a_exp + b_exp - 10'd127;
                end

                counter <= 3'd2;
            end
            3'd2: begin
                if (z_is_nan) begin
                    // Quiet NaN: Exponent all 1s, mantissa MSB 1, rest 0
                    z <= {z_sign, 8'hFF, 23'h400000};
                end else if (z_is_inf) begin
                    // Infinity: Exponent all 1s, mantissa zero
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (z_is_zero) begin
                    // Zero: sign + zero exponent + zero mantissa
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normal number: normalize product and round

                    // Check MSB (bit 47) to decide normalization shift
                    // If product[47]==1, shift right 1 and increase exponent
                    // else keep as is
                    reg [49:0] norm_prod;
                    reg [9:0] norm_exp;
                    reg [23:0] mantissa;
                    reg g, r, s;  // guard, round, sticky bits
                    integer i;

                    if (product[47]) begin
                        norm_prod = product >> 1;
                        norm_exp = z_exp + 1;
                    end else begin
                        norm_prod = product;
                        norm_exp = z_exp;
                    end

                    // Extract mantissa bits: bits [46:24]
                    mantissa = norm_prod[46:24];

                    // Extract rounding bits
                    g = norm_prod[23];
                    r = norm_prod[22];

                    // Sticky bit: OR of all bits below r bit ([21:0])
                    s = |norm_prod[21:0];

                    // Round to nearest even
                    if (g && (r || s || mantissa[0])) begin
                        mantissa = mantissa + 1;
                        // Handle mantissa overflow (carry out of 24 bits)
                        if (mantissa == 24'h1000000) begin
                            mantissa = 24'h800000; // shifted mantissa with leading 1 at bit 23
                            norm_exp = norm_exp + 1;
                        end
                    end

                    // Handle exponent overflow/underflow
                    if (norm_exp >= 10'd255) begin
                        // Overflow => infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (norm_exp <= 10'd0) begin
                        // Underflow => zero (no gradual underflow)
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Assemble final result
                        z <= {z_sign, norm_exp[7:0], mantissa[22:0]};
                    end
                end

                counter <= 3'd0; // Ready for next inputs
            end
            default: counter <= 3'd0;
        endcase
    end
end

endmodule