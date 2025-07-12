module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    // Cycle counter: 0=idle, 1=input extract & special check,
    // 2=mantissa multiply,
    // 3=normalize, round, exponent adjust,
    // 4=output assemble
    reg [2:0] counter;

    // Extracted fields
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Mantissas with implicit leading bit
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;

    // Exponents extended for calculation
    reg [9:0] a_exponent, b_exponent, z_exponent;

    // Intermediate product: 24x24=48 bits, extend to 50 bits by appending 2 zeros
    reg [49:0] product;

    // Special case flags
    reg a_is_zero, b_is_zero;
    reg a_is_inf, b_is_inf;
    reg a_is_nan, b_is_nan;
    reg special_nan, special_inf, special_zero, special_nan_from_inf_zero;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Normalized mantissa and exponent (after shifting)
    reg [49:0] norm_product;
    reg [9:0] norm_exponent;

    // Mantissa after rounding (24 bits including implicit bit)
    reg [24:0] mant_round;

    // Final mantissa and exponent for output
    reg [23:0] mant_final;
    reg [9:0] exp_final;

    // Output register signals
    reg [31:0] z_next;

    // Helper functions
    function is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction

    function is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction

    function is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    // Sequential logic for counter and output register
    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
            // Clear registers
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            a_exponent <= 10'd0; b_exponent <= 10'd0;
            product <= 50'd0;
            z_sign <= 1'b0;
            z_exponent <= 10'd0;
            z_mantissa <= 24'd0;
            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
        end else begin
            case (counter)
                3'd0: begin
                    counter <= 3'd1;
                end
                3'd1: begin
                    // Extract fields
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    // Detect special cases
                    a_is_zero <= is_zero(a[30:23], a[22:0]);
                    b_is_zero <= is_zero(b[30:23], b[22:0]);
                    a_is_inf  <= is_inf(a[30:23], a[22:0]);
                    b_is_inf  <= is_inf(b[30:23], b[22:0]);
                    a_is_nan  <= is_nan(a[30:23], a[22:0]);
                    b_is_nan  <= is_nan(b[30:23], b[22:0]);

                    // Prepare mantissas with implicit leading bit (0 for denormals)
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                    
                    // Extend exponent to 10 bits for calculation
                    a_exponent <= {2'd0, a[30:23]};
                    b_exponent <= {2'd0, b[30:23]};

                    // Compute special outputs flags
                    special_nan <= 1'b0;
                    special_inf <= 1'b0;
                    special_zero <= 1'b0;
                    special_nan_from_inf_zero <= 1'b0;

                    counter <= 3'd2;
                end
                3'd2: begin
                    // Determine special cases from extracted signals
                    special_nan_from_inf_zero <= (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);
                    special_nan <= a_is_nan || b_is_nan || special_nan_from_inf_zero;
                    special_inf <= (a_is_inf || b_is_inf) && !special_nan_from_inf_zero && !a_is_nan && !b_is_nan;
                    special_zero <= (a_is_zero || b_is_zero) && !special_nan_from_inf_zero && !special_nan && !special_inf;

                    // Sign of result
                    z_sign <= a_sign ^ b_sign;

                    // Multiply mantissas: 24 x 24 = 48 bits product
                    // Align product to 50 bits by padding 2 LSB zeros (for rounding)
                    product <= a_mantissa * b_mantissa;
                    product[49:48] <= 2'b00; // Will overwrite after multiplication

                    // Compute exponent sum: exponent_a + exponent_b - bias
                    // Note: will adjust later for normalization shift
                    z_exponent <= a_exponent + b_exponent - EXP_BIAS;

                    counter <= 3'd3;
                end
                3'd3: begin
                    // Normalization of product mantissa
                    // product is 48 bits; use product[47:0], shift to 50 bits with zeros padding
                    product <= {product[47:0], 2'b00}; // shift LSB 2 bits for rounding

                    // Normalize product:
                    // Check bit 49 (MSB) - if 1, shift right 1 and increment exponent
                    if (product[49]) begin
                        norm_product <= product >> 1;
                        norm_exponent <= z_exponent + 10'd1;
                    end else begin
                        norm_product <= product;
                        norm_exponent <= z_exponent;
                    end

                    counter <= 3'd4;
                end
                3'd4: begin
                    // Extract mantissa bits [48:25] (24 bits with implicit leading bit)
                    // Extract rounding bits guard (24), round (23), sticky (22:0)
                    z_mantissa <= norm_product[48:25];
                    guard_bit <= norm_product[24];
                    round_bit <= norm_product[23];
                    sticky_bit <= |norm_product[22:0];

                    // Round to nearest even
                    mant_round <= {1'b0, norm_product[48:25]} + 
                        ((guard_bit && (round_bit || sticky_bit || norm_product[25])) ? 25'd1 : 25'd0);

                    // Check rounding overflow
                    if (mant_round[24]) begin
                        mant_final <= mant_round[24:1];
                        exp_final <= norm_exponent + 10'd1;
                    end else begin
                        mant_final <= mant_round[23:0];
                        exp_final <= norm_exponent;
                    end

                    counter <= 3'd5;
                end
                3'd5: begin
                    // Assemble output based on special cases and exponent results
                    if (special_nan) begin
                        // Quiet NaN: sign=0, exp=all 1's, mantissa MSB=1, others zero
                        z_next = {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (special_inf) begin
                        z_next = {z_sign, 8'hFF, 23'd0};
                    end else if (special_zero) begin
                        z_next = {z_sign, 31'd0};
                    end else if (exp_final[9]) begin
                        // Overflow: exponent overflow => infinity
                        z_next = {z_sign, 8'hFF, 23'd0};
                    end else if (exp_final <= 10'd0) begin
                        // Underflow to zero (no gradual underflow handling)
                        z_next = {z_sign, 31'd0};
                    end else begin
                        // Normal case
                        z_next = {z_sign, exp_final[7:0], mant_final[22:0]};
                    end

                    z <= z_next;
                    counter <= 3'd0; // Ready for next operation
                end
                default: counter <= 3'd0;
            endcase
        end
    end

endmodule