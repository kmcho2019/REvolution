module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    reg [2:0] counter;

    // Input decode signals (combinational)
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    wire a_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_zero = (b_exp == 8'd0) && (b_frac == 23'd0);
    wire a_inf  = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_inf  = (b_exp == 8'hFF) && (b_frac == 23'd0);
    wire a_nan  = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_nan  = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Registers to hold stage data
    reg        reg_a_sign, reg_b_sign, reg_sign;
    reg [9:0]  reg_a_exp, reg_b_exp, reg_exp_sum;
    reg [23:0] reg_a_mant, reg_b_mant;      // 24 bits including implicit 1 or zero for denormals
    reg [47:0] product;                      // 24x24 multiply = 48 bits

    // Normalization and rounding variables
    reg [9:0]  norm_exp;
    reg [23:0] norm_mant;
    reg        guard_bit, round_bit, sticky_bit;

    reg [24:0] rounded_mant; // 25 bits for rounding carry

    // Flags registered at decode
    reg a_is_zero, b_is_zero;
    reg a_is_inf,  b_is_inf;
    reg a_is_nan,  b_is_nan;

    // FSM and processing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter     <= 3'd0;
            z           <= 32'd0;

            // Clear all internal registers
            reg_a_sign  <= 1'b0;
            reg_b_sign  <= 1'b0;
            reg_sign   <= 1'b0;
            reg_a_exp   <= 10'd0;
            reg_b_exp   <= 10'd0;
            reg_exp_sum <= 10'd0;
            reg_a_mant  <= 24'd0;
            reg_b_mant  <= 24'd0;
            product     <= 48'd0;

            norm_exp    <= 10'd0;
            norm_mant   <= 24'd0;
            guard_bit   <= 1'b0;
            round_bit   <= 1'b0;
            sticky_bit  <= 1'b0;

            rounded_mant <= 25'd0;

            a_is_zero   <= 1'b0;
            b_is_zero   <= 1'b0;
            a_is_inf    <= 1'b0;
            b_is_inf    <= 1'b0;
            a_is_nan    <= 1'b0;
            b_is_nan    <= 1'b0;
        end else begin
            case(counter)
                3'd0: begin
                    // Input decode cycle
                    reg_a_sign  <= a_sign;
                    reg_b_sign  <= b_sign;
                    reg_sign    <= a_sign ^ b_sign;

                    reg_a_exp   <= {2'd0, a_exp}; // extend to 10 bits
                    reg_b_exp   <= {2'd0, b_exp};

                    a_is_zero   <= a_zero;
                    b_is_zero   <= b_zero;
                    a_is_inf    <= a_inf;
                    b_is_inf    <= b_inf;
                    a_is_nan    <= a_nan;
                    b_is_nan    <= b_nan;

                    // Mantissa: add implicit leading 1 if normalized, else leading 0 for denormals
                    reg_a_mant  <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                    reg_b_mant  <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Reset downstream signals
                    reg_exp_sum <= 10'd0;
                    product    <= 48'd0;
                    norm_exp   <= 10'd0;
                    norm_mant  <= 24'd0;
                    guard_bit  <= 1'b0;
                    round_bit  <= 1'b0;
                    sticky_bit <= 1'b0;
                    rounded_mant <= 25'd0;

                    z <= 32'd0;

                    counter <= counter + 1'b1;
                end

                3'd1: begin
                    // Multiply mantissas and sum exponents
                    // Multiplication is combinational in actual hardware, register result here
                    product    <= reg_a_mant * reg_b_mant; // 24x24 = 48 bits

                    // Exponent sum with bias adjustment
                    reg_exp_sum <= reg_a_exp + reg_b_exp - EXP_BIAS;

                    counter <= counter + 1'b1;
                end

                3'd2: begin
                    // Normalization step:
                    // Check MSB of product to decide if shift needed
                    if (product[47]) begin
                        norm_mant <= product[47:24]; // top 24 bits including leading 1
                        norm_exp  <= reg_exp_sum + 10'd1;

                        // Rounding bits:
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        norm_mant <= product[46:23];
                        norm_exp  <= reg_exp_sum;

                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end

                    counter <= counter + 1'b1;
                end

                3'd3: begin
                    // Rounding - round to nearest even
                    // Round increment if guard=1 and (round=1 or sticky=1 or LSB of mantissa=1)
                    if (guard_bit && (round_bit || sticky_bit || norm_mant[0]))
                        rounded_mant <= {1'b0, norm_mant} + 25'd1;
                    else
                        rounded_mant <= {1'b0, norm_mant};

                    // Adjust exponent if mantissa overflowed after rounding
                    if ((guard_bit && (round_bit || sticky_bit || norm_mant[0])) && (rounded_mant[24] == 1'b1))
                        norm_exp <= norm_exp + 10'd1;

                    counter <= counter + 1'b1;
                end

                3'd4: begin
                    // Output generation with special case handling
                    // Assemble final output with priority:

                    // Priority: NaN > Inf * 0 = NaN > Inf > Zero > Normal number

                    if (a_is_nan || b_is_nan) begin
                        // Quiet NaN: exponent 0xFF mantissa MSB=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_is_inf || b_is_inf) begin
                        // Inf * nonzero = Inf
                        z <= {reg_sign, 8'hFF, 23'd0};
                    end else if (a_is_zero || b_is_zero) begin
                        // Zero * anything = Zero
                        z <= {reg_sign, 31'd0};
                    end else begin
                        // Normal number processing

                        // Check exponent overflow/underflow
                        if (norm_exp >= 10'd255) begin
                            // Overflow -> Inf
                            z <= {reg_sign, 8'hFF, 23'd0};
                        end else if (norm_exp <= 10'd0) begin
                            // Underflow -> flush to zero
                            z <= {reg_sign, 31'd0};
                        end else begin
                            // Normalized number output: exponent 8 bits, mantissa 23 bits (drop implicit 1)
                            // rounded_mant is 25 bits, [23:1] includes mantissa bits after rounding (drop implicit leading 1)
                            z <= {reg_sign, norm_exp[7:0], rounded_mant[23:1]};
                        end
                    end

                    // Prepare for next operation
                    counter <= 3'd0;
                end

                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule