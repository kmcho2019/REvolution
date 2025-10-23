module float_multi (
    input            clk,
    input            rst,
    input  [31:0]    a,
    input  [31:0]    b,
    output reg [31:0] z
);

    localparam EXP_BIAS = 127;

    reg [2:0] stage;  // pipeline stage: 0,1,2

    // Stage 0 registers: extracted inputs
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;
    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;
    reg [9:0] exp_sum;  // wider for overflow
    reg sign_res;

    // Stage 1 registers: mantissa multiply product
    reg [47:0] product;  // 24x24 multiply result
    reg [9:0] exp_s1;
    reg sign_s1;
    reg a_zero_s1, b_zero_s1;
    reg a_inf_s1, b_inf_s1;
    reg a_nan_s1, b_nan_s1;

    // Stage 2 registers: normalization, rounding
    reg [47:0] norm_product;
    reg [9:0] exp_s2;
    reg sign_s2;
    reg zero_s2;
    reg inf_s2;
    reg nan_s2;
    reg nan_invalid_s2;

    // Rounding and mantissa registers
    reg [23:0] mantissa_pre_round; // top 24 bits from norm product
    reg guard_bit, round_bit, sticky_bit;
    reg round_increment;
    reg [24:0] mantissa_rounded; // 25 bits to detect overflow
    reg [23:0] mantissa_final;
    reg [9:0] exp_final;

    // Helpers for special case detection (combinational)
    function is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction

    function is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction

    function is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    always @(posedge clk) begin
        if (rst) begin
            stage <= 0;
            z <= 32'd0;

            // Clear all registers
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;
            a_zero <= 1'b0; b_zero <= 1'b0;
            a_inf <= 1'b0; b_inf <= 1'b0;
            a_nan <= 1'b0; b_nan <= 1'b0;
            exp_sum <= 10'd0; sign_res <= 1'b0;

            product <= 48'd0; exp_s1 <= 10'd0; sign_s1 <= 1'b0;
            a_zero_s1 <= 1'b0; b_zero_s1 <= 1'b0; a_inf_s1 <= 1'b0; b_inf_s1 <= 1'b0; a_nan_s1 <= 1'b0; b_nan_s1 <= 1'b0;

            norm_product <= 48'd0; exp_s2 <= 10'd0; sign_s2 <= 1'b0;
            zero_s2 <= 1'b0; inf_s2 <= 1'b0; nan_s2 <= 1'b0; nan_invalid_s2 <= 1'b0;

            mantissa_pre_round <= 24'd0;
            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
            round_increment <= 1'b0;
            mantissa_rounded <= 25'd0;
            mantissa_final <= 24'd0;
            exp_final <= 10'd0;
        end else begin
            case(stage)
                3'd0: begin
                    // Extract fields
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    a_zero <= is_zero(a[30:23], a[22:0]);
                    b_zero <= is_zero(b[30:23], b[22:0]);
                    a_inf <= is_inf(a[30:23], a[22:0]);
                    b_inf <= is_inf(b[30:23], b[22:0]);
                    a_nan <= is_nan(a[30:23], a[22:0]);
                    b_nan <= is_nan(b[30:23], b[22:0]);

                    sign_res <= a[31] ^ b[31];

                    // Exponent sum = a_exp + b_exp - bias
                    // If zero or denorm, exponent is zero, treated as zero mantissa without leading 1
                    exp_sum <= ( (a[30:23]==8'd0) ? 0 : a[30:23]) + ((b[30:23]==8'd0) ? 0 : b[30:23]) - EXP_BIAS;

                    stage <= 3'd1;
                end

                3'd1: begin
                    // Prepare mantissas with implied leading 1 for normalized numbers
                    // For denormals exponent=0 so leading 0, else 1
                    // Multiply mantissas 24x24 bits
                    reg [23:0] a_mant;
                    reg [23:0] b_mant;

                    a_mant = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_mant = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

                    product <= a_mant * b_mant; // 48-bit product

                    exp_s1 <= exp_sum;
                    sign_s1 <= sign_res;

                    // Pass special flags
                    a_zero_s1 <= a_zero;
                    b_zero_s1 <= b_zero;
                    a_inf_s1 <= a_inf;
                    b_inf_s1 <= b_inf;
                    a_nan_s1 <= a_nan;
                    b_nan_s1 <= b_nan;

                    stage <= 3'd2;
                end

                3'd2: begin
                    // Handle special cases
                    // Detect invalid NaN (Inf * 0)
                    nan_invalid_s2 <= ((a_inf_s1 && b_zero_s1) || (b_inf_s1 && a_zero_s1));
                    nan_s2 <= a_nan_s1 || b_nan_s1 || nan_invalid_s2;
                    inf_s2 <= (a_inf_s1 || b_inf_s1) && !nan_invalid_s2;
                    zero_s2 <= (a_zero_s1 || b_zero_s1) && !nan_invalid_s2 && !inf_s2;

                    sign_s2 <= sign_s1;

                    // Normalize product
                    // product[47] is MSB
                    if (product[47]) begin
                        norm_product <= product >> 1;
                        exp_s2 <= exp_s1 + 1;
                    end else begin
                        norm_product <= product;
                        exp_s2 <= exp_s1;
                    end

                    // Extract bits for rounding:
                    // mantissa bits are bits [46:23]
                    mantissa_pre_round <= (product[47]) ? (product >> 1)[46:23] : product[46:23];
                    guard_bit <= ((product[47]) ? (product >> 1) : product)[23];
                    round_bit <= ((product[47]) ? (product >> 1) : product)[22];
                    sticky_bit <= |(((product[47]) ? (product >> 1) : product)[21:0]);

                    stage <= 3'd3;
                end

                3'd3: begin
                    // Round to nearest even
                    round_increment <= guard_bit && (round_bit || sticky_bit || mantissa_pre_round[0]);
                    mantissa_rounded <= {1'b0, mantissa_pre_round} + round_increment;

                    // If mantissa overflow after rounding
                    if (mantissa_rounded[24]) begin
                        mantissa_final <= mantissa_rounded[24:1];
                        exp_final <= exp_s2 + 1;
                    end else begin
                        mantissa_final <= mantissa_rounded[23:0];
                        exp_final <= exp_s2;
                    end

                    stage <= 3'd4;
                end

                3'd4: begin
                    // Output formatting and special cases handling

                    if (nan_s2) begin
                        // Quiet NaN: sign=0, exp=255, MSB mantissa=1, rest zero
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (inf_s2) begin
                        z <= {sign_s2, 8'hFF, 23'd0};
                    end else if (zero_s2) begin
                        z <= {sign_s2, 31'd0};
                    end else if (exp_final[9:8] != 2'b00) begin
                        // Overflow: set Inf
                        z <= {sign_s2, 8'hFF, 23'd0};
                    end else if (exp_final == 0) begin
                        // Underflow or zero exponent => zero output (no subnormal)
                        z <= {sign_s2, 31'd0};
                    end else begin
                        // Normal number
                        z <= {sign_s2, exp_final[7:0], mantissa_final[22:0]};
                    end

                    // Loop back to stage 0 for next operation
                    stage <= 3'd0;
                end

                default: stage <= 3'd0;
            endcase
        end
    end

endmodule