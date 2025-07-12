module float_multi (
    input           clk,
    input           rst,
    input           start,          // Start signal for multiplication (pulse)
    input  [31:0]   a,              // Operand a in IEEE-754 single precision
    input  [31:0]   b,              // Operand b in IEEE-754 single precision
    output reg [31:0] z,            // Result in IEEE-754 single precision
    output reg      done             // Output valid signal (pulse)
);

    localparam EXP_BIAS = 127;
    localparam IDLE = 1'b0;
    localparam DONE = 1'b1;

    reg state, next_state;

    // Input registers latched on start
    reg a_sign_r, b_sign_r;
    reg [7:0] a_exp_r, b_exp_r;
    reg [22:0] a_frac_r, b_frac_r;

    // Extracted signals from latched inputs
    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    // Mantissas with hidden bit for normalized numbers
    reg [23:0] a_mant, b_mant;

    // Result intermediate signals
    reg sign_r;
    reg [9:0] exp_sum; // extended 10-bit exponent sum for overflow detection
    reg [47:0] product; // 24x24 bit mantissa multiplication

    // Normalized mantissa and exponent after multiplication
    reg [47:0] norm_product;
    reg [9:0] norm_exp;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Mantissa after rounding
    reg [24:0] mantissa_rounded; // 25 bits to include carry

    // Special cases flags
    reg special_nan, special_inf, special_zero, special_invalid;

    // Internal sticky bit calculation function: OR reduction for bits [22:0] below round bit
    function automatic sticky_calc(input [22:0] bits);
        integer i;
        begin
            sticky_calc = 1'b0;
            for (i=0; i<23; i=i+1) begin
                if(bits[i])
                    sticky_calc = 1'b1;
            end
        end
    endfunction

    // Function to determine zero input
    function automatic is_zero(input [7:0] exp_in, input [22:0] frac_in);
        begin
            is_zero = (exp_in == 8'd0) && (frac_in == 23'd0);
        end
    endfunction

    // Function to determine infinity input
    function automatic is_inf(input [7:0] exp_in, input [22:0] frac_in);
        begin
            is_inf = (exp_in == 8'hFF) && (frac_in == 23'd0);
        end
    endfunction

    // Function to determine NaN input
    function automatic is_nan(input [7:0] exp_in, input [22:0] frac_in);
        begin
            is_nan = (exp_in == 8'hFF) && (frac_in != 23'd0);
        end
    endfunction

    // FSM state register
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = start ? DONE : IDLE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Main sequential logic: latch inputs and compute outputs
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            // Reset outputs and internal registers
            z <= 32'd0;
            done <= 1'b0;

            a_sign_r <= 1'b0; b_sign_r <= 1'b0;
            a_exp_r <= 8'd0; b_exp_r <= 8'd0;
            a_frac_r <= 23'd0; b_frac_r <= 23'd0;

            a_zero <= 1'b0; b_zero <= 1'b0;
            a_inf <= 1'b0; b_inf <= 1'b0;
            a_nan <= 1'b0; b_nan <= 1'b0;

            a_mant <= 24'd0; b_mant <= 24'd0;

            sign_r <= 1'b0;
            exp_sum <= 10'd0;
            product <= 48'd0;
            norm_product <= 48'd0;
            norm_exp <= 10'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;
            mantissa_rounded <= 25'd0;

            special_nan <= 1'b0;
            special_inf <= 1'b0;
            special_zero <= 1'b0;
            special_invalid <= 1'b0;
        end else begin
            done <= 1'b0; // Default done low, assert only in DONE state

            if(state == IDLE && start) begin
                // Latch inputs at start pulse
                a_sign_r <= a[31];
                b_sign_r <= b[31];
                a_exp_r <= a[30:23];
                b_exp_r <= b[30:23];
                a_frac_r <= a[22:0];
                b_frac_r <= b[22:0];

                // Determine special cases on latched inputs
                a_zero <= is_zero(a[30:23], a[22:0]);
                b_zero <= is_zero(b[30:23], b[22:0]);
                a_inf <= is_inf(a[30:23], a[22:0]);
                b_inf <= is_inf(b[30:23], b[22:0]);
                a_nan <= is_nan(a[30:23], a[22:0]);
                b_nan <= is_nan(b[30:23], b[22:0]);

                // Form mantissa with hidden bit for normalized, zero for denormalized
                a_mant <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mant <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
            end

            if(state == DONE) begin
                // Start calculations on latched inputs in the DONE cycle:

                // Special cases handling:

                // Sign of output is XOR of input signs
                sign_r <= a_sign_r ^ b_sign_r;

                // Detect special cases in output:
                // NaN if either operand NaN or invalid inf*0
                special_nan <= a_nan || b_nan;

                // Invalid inf*0 detected:
                special_invalid <= (a_inf && b_zero) || (b_inf && a_zero);

                // Infinity output if either is infinity (and not invalid case)
                special_inf <= (a_inf || b_inf) && !special_invalid;

                // Zero output if either zero (and not invalid or inf)
                special_zero <= (a_zero || b_zero) && !special_invalid && !special_inf;

                // Exponent sum adjusted for bias (bias subtracted once)
                exp_sum <= a_exp_r + b_exp_r - EXP_BIAS;

                // Mantissa product
                product <= a_mant * b_mant;

                // Normalization: product is 48-bit, upper 24 bits mantissa candidate
                if(product[47] == 1'b1) begin
                    // Leading 1 at MSB position => shift right by 1 and increase exponent
                    norm_product <= product >> 1;
                    norm_exp <= exp_sum + 10'd1;
                end else begin
                    norm_product <= product;
                    norm_exp <= exp_sum;
                end

                // Extract rounding bits:
                // Mantissa bits for output are bits [46:23] (24 bits)
                // Guard bit: bit 22
                // Round bit: bit 21
                // Sticky bit: OR of bits [20:0]

                guard_bit <= norm_product[23];
                round_bit <= norm_product[22];
                sticky_bit <= (|norm_product[21:0]) ? 1'b1 : 1'b0;

                // Prepare mantissa for rounding: 24 bits
                // mantissa field is norm_product[46:23]
                // Will add rounding bit next cycle
                // Here we form the 25-bit mantissa_rounded next cycle with rounding

                // Rounding decision (round to nearest even):
                // if guard=1 and (round=1 or sticky=1 or LSB of mantissa=1), round up
                if(guard_bit && (round_bit || sticky_bit || norm_product[23])) begin
                    mantissa_rounded <= {1'b0, norm_product[46:23]} + 25'd1;
                end else begin
                    mantissa_rounded <= {1'b0, norm_product[46:23]};
                end

                // Adjust exponent if rounding overflows mantissa
                if(mantissa_rounded[24] == 1'b1) begin
                    // Mantissa overflowed, shift right and increase exponent by 1
                    z <= {sign_r, norm_exp[7:0] + 8'd1, mantissa_rounded[23:1]};
                end else begin
                    z <= {sign_r, norm_exp[7:0], mantissa_rounded[22:0]};
                end

                // Handle special cases final output:
                // Priority: NaN > invalid NaN > Inf > Zero > Normal

                if(special_nan || special_invalid) begin
                    // Quiet NaN canonical: sign=0, exp=all 1s, MSB frac=1, rest 0
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if(special_inf) begin
                    z <= {sign_r, 8'hFF, 23'd0}; // Infinity
                end else if(special_zero) begin
                    z <= {sign_r, 31'd0};        // Zero
                end else if(norm_exp >= 10'd255) begin
                    // Overflow exponent to infinity
                    z <= {sign_r, 8'hFF, 23'd0};
                end else if(norm_exp <= 10'd0) begin
                    // Underflow exponent to zero (no subnormal handling)
                    z <= {sign_r, 31'd0};
                end

                done <= 1'b1;
            end
        end
    end

endmodule