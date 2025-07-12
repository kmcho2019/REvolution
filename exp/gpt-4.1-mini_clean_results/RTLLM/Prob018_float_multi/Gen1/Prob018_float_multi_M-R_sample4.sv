module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // FSM states
    typedef enum reg [2:0] {
        IDLE       = 3'd0,
        EXTRACT    = 3'd1,
        SPECIAL    = 3'd2,
        MULTIPLY   = 3'd3,
        NORMALIZE  = 3'd4,
        ROUND      = 3'd5,
        FINISH     = 3'd6
    } state_t;

    reg [2:0] state, next_state;

    // Intermediate registers

    // Signs
    reg a_sign, b_sign, z_sign;

    // Exponents extended width (10 bits)
    reg [9:0] a_exponent, b_exponent, z_exponent;

    // Mantissas with implicit leading 1 for normalized (24 bits)
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;

    // Product: 24 x 24 = 48 bits, keep 50 bits for rounding bits and shifts
    reg [49:0] product;

    // Rounding bits
    reg guard_bit, round_bit, sticky;

    // Special flags for input operands
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;

    // Constants
    localparam BIAS = 127;

    // Extract input fields (combinational)
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];
    wire a_s = a[31];
    wire b_s = b[31];

    // Helper functions (combinational)
    function is_nan(input [7:0] exp, input [22:0] frac);
        begin
            is_nan = (exp == 8'hFF) && (frac != 0);
        end
    endfunction

    function is_inf(input [7:0] exp, input [22:0] frac);
        begin
            is_inf = (exp == 8'hFF) && (frac == 0);
        end
    endfunction

    function is_zero(input [7:0] exp, input [22:0] frac);
        begin
            is_zero = (exp == 0) && (frac == 0);
        end
    endfunction

    // Sticky bit calculation helper for normalization
    // Used to OR bits shifted out during normalization (down to bit 0)
    // Implemented inside state machine logic as needed

    // FSM state register and next state logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 32'b0;
            // Clear all regs
            a_sign <= 0;
            b_sign <= 0;
            z_sign <= 0;
            a_exponent <= 0;
            b_exponent <= 0;
            z_exponent <= 0;
            a_mantissa <= 0;
            b_mantissa <= 0;
            z_mantissa <= 0;
            product <= 0;
            guard_bit <= 0;
            round_bit <= 0;
            sticky <= 0;
            a_zero <= 0;
            b_zero <= 0;
            a_inf <= 0;
            b_inf <= 0;
            a_nan <= 0;
            b_nan <= 0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    z <= 32'b0;
                    // Wait for inputs; move to EXTRACT immediately
                    next_state <= EXTRACT;
                end

                EXTRACT: begin
                    // Extract signs
                    a_sign <= a_s;
                    b_sign <= b_s;

                    // Extend exponents to 10 bits
                    a_exponent <= {2'b00, a_exp};
                    b_exponent <= {2'b00, b_exp};

                    // Flags
                    a_zero <= is_zero(a_exp, a_frac);
                    b_zero <= is_zero(b_exp, b_frac);
                    a_inf <= is_inf(a_exp, a_frac);
                    b_inf <= is_inf(b_exp, b_frac);
                    a_nan <= is_nan(a_exp, a_frac);
                    b_nan <= is_nan(b_exp, b_frac);

                    // Mantissas with implicit leading 1 if normalized, else no leading 1 (denormals)
                    a_mantissa <= (a_exp == 8'b0) ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_mantissa <= (b_exp == 8'b0) ? {1'b0, b_frac} : {1'b1, b_frac};

                    next_state <= SPECIAL;
                end

                SPECIAL: begin
                    // Handle special cases according to IEEE 754 rules

                    if (a_nan || b_nan) begin
                        // Output Quiet NaN: sign=0, exponent=all 1s, MSB fraction=1, rest=0
                        z <= {1'b0, 8'hFF, 1'b1, 22'b0};
                        next_state <= IDLE;
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'b0};
                        next_state <= IDLE;
                    end else if (a_inf || b_inf) begin
                        // Inf * finite nonzero = Inf
                        z_sign <= a_sign ^ b_sign;
                        z_exponent <= 10'd255;
                        z_mantissa <= 24'b0;
                        z <= {a_sign ^ b_sign, 8'hFF, 23'b0};
                        next_state <= IDLE;
                    end else if (a_zero || b_zero) begin
                        // Zero * anything = zero
                        z_sign <= a_sign ^ b_sign;
                        z_exponent <= 10'd0;
                        z_mantissa <= 24'b0;
                        z <= {a_sign ^ b_sign, 8'd0, 23'd0};
                        next_state <= IDLE;
                    end else begin
                        // Normal path
                        z_sign <= a_sign ^ b_sign;
                        next_state <= MULTIPLY;
                    end
                end

                MULTIPLY: begin
                    // Multiply mantissas
                    // product is 48 bits in bits [47:0], stored in 50 bits reg to accommodate rounding bits and shifts
                    product <= a_mantissa * b_mantissa;

                    // Add exponents and subtract bias
                    // Use 10 bit exponents to avoid overflow
                    z_exponent <= a_exponent + b_exponent - BIAS;

                    next_state <= NORMALIZE;
                end

                NORMALIZE: begin
                    // Normalize the product mantissa and adjust exponent
                    // If MSB of product (bit 47) is 1, no shift needed
                    // Else shift left by 1, decrement exponent

                    if (product[47]) begin
                        // Already normalized
                        z_mantissa <= product[46:23]; // take bits 46 down to 23 as mantissa

                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky <= |product[20:0];

                        // exponent stays
                        z_exponent <= z_exponent;
                        next_state <= ROUND;
                    end else begin
                        // Shift left by 1
                        product <= product << 1;
                        z_exponent <= z_exponent - 1'b1;

                        z_mantissa <= (product << 1)[46:23];
                        guard_bit <= (product << 1)[22];
                        round_bit <= (product << 1)[21];
                        sticky <= |(product << 1)[20:0];

                        next_state <= ROUND;
                    end
                end

                ROUND: begin
                    // Round to nearest even using guard, round, sticky bits
                    // rounding_condition = guard & (round | sticky | LSB of mantissa)
                    if (guard_bit && (round_bit | sticky | z_mantissa[0])) begin
                        {z_exponent, z_mantissa} <= {z_exponent, z_mantissa} + 1'b1;
                    end

                    // Check for mantissa overflow after rounding (mantissa 24 bits, MSB implicit 1)
                    // If mantissa overflows beyond 24 bits (i.e. becomes 25 bits), shift right and increase exponent
                    if (z_mantissa[23] == 1'b0) begin
                        // no overflow
                        next_state <= FINISH;
                    end else if (z_mantissa == 24'h1000000) begin
                        // overflow detected: 25 bits, shift right 1, increment exponent
                        z_mantissa <= z_mantissa >> 1;
                        z_exponent <= z_exponent + 1'b1;
                        next_state <= FINISH;
                    end else begin
                        next_state <= FINISH;
                    end
                end

                FINISH: begin
                    // Handle overflow/underflow and output final result

                    if (z_exponent >= 10'd255) begin
                        // Overflow -> infinity
                        z <= {z_sign, 8'hFF, 23'b0};
                    end else if (z_exponent <= 0) begin
                        // Underflow -> zero
                        z <= {z_sign, 8'd0, 23'd0};
                    end else begin
                        // Normal number
                        // Remove implicit leading 1 (bit 23) from mantissa for IEEE 754 fraction field
                        z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                    end

                    next_state <= IDLE;
                end

                default: begin
                    // Should not occur, reset state
                    next_state <= IDLE;
                    z <= 32'b0;
                end
            endcase
        end
    end

endmodule