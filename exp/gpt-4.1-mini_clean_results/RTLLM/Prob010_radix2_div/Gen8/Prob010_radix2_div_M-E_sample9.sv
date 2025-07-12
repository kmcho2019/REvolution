module radix2_div (
    input          clk,
    input          rst,
    input          sign,          // 1: signed, 0: unsigned
    input   [7:0]  dividend,
    input   [7:0]  divisor,
    input          opn_valid,
    output reg     res_valid,
    output  [15:0] result         // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        RUN  = 2'b01,
        DONE = 2'b10
    } state_t;

    state_t state, next_state;

    // Input latches and sign flags
    reg [7:0] dividend_r, divisor_r;
    reg       dividend_neg, divisor_neg;

    // Unsigned magnitudes
    reg [7:0] dividend_mag, divisor_mag;

    // Combined shift register: {remainder[8:0], quotient[7:0]} 17 bits
    reg [16:0] SR;

    reg [3:0] count; // Count division steps 0..8

    // Signals for subtraction
    wire [8:0] remainder = SR[16:8];
    wire [8:0] divisor_ext = {1'b0, divisor_mag};
    wire [8:0] sub_res = remainder - divisor_ext;
    wire       borrow = sub_res[8]; // borrow if MSB=1

    // Next quotient bit depends on borrow
    wire       quotient_bit = borrow ? 1'b0 : 1'b1;
    wire [8:0] new_remainder = borrow ? remainder : sub_res;

    // Registers for corrected quotient and remainder after division
    reg [7:0] quotient_corr, remainder_corr;

    // Output registers
    reg [15:0] result_reg;

    // Sign calculations
    wire quotient_neg = sign & (dividend_neg ^ divisor_neg);
    wire remainder_neg = sign & dividend_neg;

    // FSM sequential logic and main datapath
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= IDLE;
            SR            <= 17'd0;
            dividend_r    <= 8'd0;
            divisor_r     <= 8'd0;
            dividend_neg  <= 1'b0;
            divisor_neg   <= 1'b0;
            dividend_mag  <= 8'd0;
            divisor_mag   <= 8'd0;
            count         <= 4'd0;
            quotient_corr <= 8'd0;
            remainder_corr<= 8'd0;
            res_valid     <= 1'b0;
            result_reg    <= 16'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid && divisor != 8'd0) begin
                        // Latch inputs
                        dividend_r <= dividend;
                        divisor_r  <= divisor;

                        // Extract signs and magnitude for signed division
                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg  <= divisor[7];
                            dividend_mag <= dividend[7] ? (~dividend + 8'd1) : dividend;
                            divisor_mag  <= divisor[7] ? (~divisor  + 8'd1) : divisor;
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg  <= 1'b0;
                            dividend_mag <= dividend;
                            divisor_mag  <= divisor;
                        end

                        // Initialize SR: remainder=0, quotient=dividend_mag
                        SR <= {9'd0, dividend_mag};
                        count <= 4'd0;
                    end
                end
                RUN: begin
                    // Shift left SR by 1 bit
                    // Before shifting, attempt subtract
                    // We implement restoring division:
                    // - Shift left remainder and quotient by 1 bit (combined)
                    // - Subtract divisor_mag from remainder portion
                    // - If no borrow, update remainder and set quotient bit to 1
                    // - Else, restore remainder and set quotient bit to 0

                    // Step 1: Shift left by 1
                    reg [16:0] shifted_SR;
                    shifted_SR = {SR[15:0], 1'b0};

                    // Step 2: Perform subtraction on remainder portion (shifted_SR[16:8])
                    // sub_res and borrow defined combinationally above using SR, need to use shifted remainder

                    // Note: We must base subtraction on the new remainder (shifted left by 1)
                    // So first, calculate shifted remainder:
                    reg [8:0] rem_shifted;
                    rem_shifted = {SR[16:8], 1'b0} << 1; // 9 bits shifted left 1 bit, but note SR bits count.

                    // The above line is off because SR[16:8] is 9 bits; shifting left by 1 doubles to 10 bits.
                    // We only want to shift combined SR left by 1, done already as shifted_SR.

                    // So remainder after shift is shifted_SR[16:8]
                    // Let's assign remainder_after_shift:
                    reg [8:0] remainder_after_shift;
                    remainder_after_shift = shifted_SR[16:8];

                    // Now subtract divisor_mag from remainder_after_shift:
                    reg [8:0] subtract_result;
                    reg       borrow_subtract;
                    subtract_result = remainder_after_shift - {1'b0, divisor_mag};
                    borrow_subtract = subtract_result[8];

                    if (!borrow_subtract) begin
                        // No borrow: accept subtraction result, quotient LSB = 1
                        SR <= {subtract_result, shifted_SR[7:1], 1'b1};
                    end else begin
                        // Borrow occurred: restore remainder, quotient LSB=0
                        SR <= {remainder_after_shift, shifted_SR[7:1], 1'b0};
                    end

                    count <= count + 1'b1;
                end
                DONE: begin
                    // Apply sign correction for quotient and remainder

                    // Extract raw quotient and remainder
                    reg [7:0] raw_quotient;
                    reg [7:0] raw_remainder;

                    raw_quotient = SR[7:0];
                    raw_remainder = SR[16:9]; // 8 bits remainder (top 8 bits of 9-bit remainder)

                    // Correct quotient sign
                    if (quotient_neg)
                        quotient_corr <= (~raw_quotient + 8'd1);
                    else
                        quotient_corr <= raw_quotient;

                    // Correct remainder sign
                    if (remainder_neg)
                        remainder_corr <= (~raw_remainder + 8'd1);
                    else
                        remainder_corr <= raw_remainder;

                    // Output result
                    result_reg <= {remainder_corr, quotient_corr};
                    res_valid <= 1'b1;

                    // Stay here until next opn_valid
                    if (!opn_valid)
                        res_valid <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (opn_valid && divisor != 8'd0)
                    next_state = RUN;
            end
            RUN: begin
                if (count == 4'd8)
                    next_state = DONE;
            end
            DONE: begin
                if (!opn_valid)
                    next_state = IDLE;
            end
        endcase
    end

    assign result = result_reg;

endmodule