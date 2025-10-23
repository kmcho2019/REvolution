module radix2_div (
    input               clk,
    input               rst,
    input               sign,
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg  [15:0]  result
);

    // FSM states
    typedef enum logic [1:0] {IDLE=2'b00, RUN=2'b01, DONE=2'b10} state_t;
    state_t state, next_state;

    // Internal registers
    reg [3:0] cnt;

    // Absolute values and sign flags
    reg [7:0] dividend_abs;
    reg [8:0] divisor_abs; // extend to 9 bits for subtraction with remainder
    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;

    // Data path registers
    reg [8:0] remainder; // 9 bits to hold shifted remainder
    reg [7:0] quotient;

    // Next values for combinational logic
    reg [8:0] remainder_next;
    reg [7:0] quotient_next;

    // Subtraction result signal
    wire signed [9:0] sub_res;

    // Calculate subtraction: remainder - divisor_abs
    assign sub_res = $signed({1'b0, remainder}) - $signed(divisor_abs);

    // Combinational next state logic and data path calculation
    always @(*) begin
        // Default values
        next_state = state;
        remainder_next = remainder;
        quotient_next = quotient;

        case(state)
            IDLE: begin
                if (opn_valid) begin
                    next_state = RUN;
                end
            end

            RUN: begin
                if (cnt == 4'd8) begin
                    next_state = DONE;
                end else begin
                    next_state = RUN;

                    // Shift left remainder and quotient (shift remainder by 1 bit left, bring in MSB of quotient)
                    // But dividend bits are fixed, so shift remainder left by 1, shift quotient left by 1
                    // Insert next bit 0 at LSB of quotient at this stage; then decide quotient bit after subtraction

                    // Temporary shift left:
                    // remainder shifted left by 1
                    // quotient shifted left by 1
                    // We'll set quotient_next[0] based on subtraction result

                    // Perform subtraction on shifted remainder
                    if (sub_res >= 0) begin
                        // Subtraction successful: update remainder to sub_res and set quotient bit to 1
                        remainder_next = sub_res[8:0];
                        quotient_next = {quotient[6:0], 1'b1};
                    end else begin
                        // Restore remainder (no change), quotient bit = 0
                        remainder_next = remainder << 1;
                        quotient_next = {quotient[6:0], 1'b0};
                    end
                end
            end

            DONE: begin
                next_state = IDLE; // Automatically go back to IDLE after done
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state and data registers
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            cnt <= 4'd0;
            remainder <= 9'd0;
            quotient <= 8'd0;
            res_valid <= 1'b0;
            result <= 16'd0;
            dividend_abs <= 8'd0;
            divisor_abs <= 9'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    if (opn_valid) begin
                        // Calculate absolute values and sign flags
                        if (sign && dividend[7]) begin
                            dividend_abs <= (~dividend) + 1'b1;
                            dividend_neg <= 1'b1;
                        end else begin
                            dividend_abs <= dividend;
                            dividend_neg <= 1'b0;
                        end

                        if (sign && divisor[7]) begin
                            divisor_abs <= {1'b0, (~divisor) + 1'b1};
                            divisor_neg <= 1'b1;
                        end else begin
                            divisor_abs <= {1'b0, divisor};
                            divisor_neg <= 1'b0;
                        end

                        quotient_neg <= sign && (dividend[7] ^ divisor[7]);
                        remainder_neg <= sign && dividend[7];

                        // Initialize registers
                        remainder <= {1'b0, dividend_abs}; // 9-bit remainder = dividend_abs zero-extended
                        quotient <= 8'd0;
                    end
                end

                RUN: begin
                    cnt <= cnt + 1'b1;
                    // Shift remainder left by 1 before subtraction if needed
                    // Implement logic from combinational block
                    if (sub_res >= 0) begin
                        // remainder updated to sub_res, quotient bit=1
                        remainder <= sub_res[8:0];
                        quotient <= {quotient[6:0], 1'b1};
                    end else begin
                        // remainder shifted left by 1, quotient bit=0
                        remainder <= remainder << 1;
                        quotient <= {quotient[6:0], 1'b0};
                    end
                end

                DONE: begin
                    // Apply sign correction to quotient and remainder
                    reg [7:0] quotient_corr;
                    reg [7:0] remainder_corr;
                    reg [7:0] rem_8bit;

                    // remainder is 9 bits, drop MSB for 8-bit remainder output (assuming remainder fits)
                    rem_8bit = remainder[7:0];

                    if (sign) begin
                        // Quotient sign correction
                        if (quotient_neg)
                            quotient_corr = (~quotient) + 1'b1;
                        else
                            quotient_corr = quotient;

                        // Remainder sign correction
                        if (remainder_neg)
                            remainder_corr = (~rem_8bit) + 1'b1;
                        else
                            remainder_corr = rem_8bit;
                    end else begin
                        quotient_corr = quotient;
                        remainder_corr = rem_8bit;
                    end

                    result <= {remainder_corr, quotient_corr};
                    res_valid <= 1'b1;
                    cnt <= 4'd0;
                end

                default: begin
                    // Safe defaults
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    remainder <= 9'd0;
                    quotient <= 8'd0;
                end
            endcase
        end
    end

endmodule