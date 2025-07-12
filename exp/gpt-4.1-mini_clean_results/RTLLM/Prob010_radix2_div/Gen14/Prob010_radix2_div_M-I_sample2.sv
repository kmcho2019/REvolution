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
    typedef enum logic [1:0] {
        IDLE    = 2'd0,
        RUN     = 2'd1,
        FINISH  = 2'd2
    } state_t;
    state_t state, next_state;

    reg [3:0] cnt;         // iteration counter (0 to 8)
    reg [16:0] SR;         // {partial_remainder[8:0], quotient[7:0]}
    reg [8:0] divisor_abs; // 9-bit extended absolute divisor

    // Sign flags
    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;

    reg [7:0] dividend_abs;
    reg [7:0] divisor_val;

    // Intermediate combinational signals for RUN state
    wire signed [9:0] pr;          // partial remainder signed (9 bits extended to 10 bits)
    wire signed [9:0] divisor_s;   // signed divisor extended to 10 bits
    wire signed [9:0] pr_shifted;  // partial remainder shifted left by 1 plus next bit
    wire signed [9:0] pr_next;     // partial remainder after add/subtract divisor
    wire next_qbit;                // next quotient bit after comparison

    // Partial remainder is upper 9 bits of SR (bits 16 down to 8)
    assign pr = $signed(SR[16:8]);
    assign divisor_s = $signed({1'b0, divisor_abs}); // extend divisor_abs to 10 bits

    // pr_shifted: shift partial remainder left by 1 bit and insert old quotient MSB as LSB
    assign pr_shifted = {pr[8:0], 1'b0} | {9'd0, SR[7]};

    // pr_next depends on sign of pr:
    // if pr >= 0, pr_next = pr_shifted - divisor_s
    // else pr_next = pr_shifted + divisor_s
    assign pr_next = (pr >= 0) ? (pr_shifted - divisor_s) : (pr_shifted + divisor_s);

    // next quotient bit is 1 if pr_next >= 0, else 0
    assign next_qbit = ~pr_next[9];

    // FSM sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            cnt <= 4'd0;
            SR <= 17'd0;
            res_valid <= 1'b0;
            result <= 16'd0;

            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;

            dividend_abs <= 8'd0;
            divisor_abs <= 9'd0;
            divisor_val <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Capture inputs, determine sign flags, and compute absolute values
                        if (sign && dividend[7]) begin
                            dividend_abs <= (~dividend) + 1'b1;
                            dividend_neg <= 1'b1;
                        end else begin
                            dividend_abs <= dividend;
                            dividend_neg <= 1'b0;
                        end

                        if (sign && divisor[7]) begin
                            divisor_val <= (~divisor) + 1'b1;
                            divisor_neg <= 1'b1;
                        end else begin
                            divisor_val <= divisor;
                            divisor_neg <= 1'b0;
                        end

                        quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                        remainder_neg <= (sign && dividend[7]);

                        // Extend divisor to 9 bits (zero MSB)
                        divisor_abs <= {1'b0, divisor_val};

                        // Initialize SR: partial remainder = dividend_abs shifted left by 1 (9 bits),
                        // quotient = 0
                        // SR = {partial_remainder[8:0], quotient[7:0]}
                        SR <= {dividend_abs, 1'b0, 8'd0};

                        cnt <= 4'd0;
                        state <= RUN;
                    end else begin
                        state <= IDLE;
                    end
                end

                RUN: begin
                    // Update SR and counter
                    // SR := {pr_next[8:0], SR[7:0] << 1 | next_qbit}
                    SR <= {pr_next[8:0], (SR[7:0] << 1) | next_qbit};

                    cnt <= cnt + 1'b1;
                    if (cnt == 4'd7) begin
                        state <= FINISH;
                    end else begin
                        state <= RUN;
                    end
                end

                FINISH: begin
                    // Final correction: if partial remainder negative, add divisor back
                    reg signed [9:0] pr_final;
                    reg [16:0] SR_final;
                    reg [7:0] quotient_raw;
                    reg [7:0] remainder_raw;
                    reg [7:0] quotient_corr;
                    reg [7:0] remainder_corr;

                    pr_final = $signed(SR[16:8]);
                    if (pr_final < 0) begin
                        pr_final = pr_final + $signed(divisor_abs);
                    end
                    SR_final = {pr_final[8:0], SR[7:0]};
                    SR <= SR_final;

                    quotient_raw = SR_final[7:0];
                    remainder_raw = SR_final[16:9]; // upper 8 bits of PR

                    // Sign correction on quotient and remainder if signed operation
                    if (sign) begin
                        quotient_corr = quotient_neg ? ((~quotient_raw) + 1'b1) : quotient_raw;
                        remainder_corr = remainder_neg ? ((~remainder_raw) + 1'b1) : remainder_raw;
                    end else begin
                        quotient_corr = quotient_raw;
                        remainder_corr = remainder_raw;
                    end

                    result <= {remainder_corr, quotient_corr};
                    res_valid <= 1'b1;

                    cnt <= 4'd0;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule