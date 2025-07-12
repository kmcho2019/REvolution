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

    // States for FSM
    typedef enum logic [1:0] {
        IDLE    = 2'd0,
        RUN     = 2'd1,
        FINISH  = 2'd2
    } state_t;
    state_t state, next_state;

    reg [3:0] cnt; // iteration count 0 to 8
    reg [16:0] SR; // shift register: {partial_remainder(9 bits), quotient(8 bits)}
    reg [8:0] divisor_abs; // absolute divisor (9 bits)
    reg [8:0] divisor_ext; // extended for addition/subtraction

    // Signs
    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;

    reg [7:0] dividend_abs;
    reg [7:0] divisor_val;

    wire signed [9:0] pr; // partial remainder signed (9-bit extended to 10 bits for arithmetic)
    wire signed [9:0] divisor_s;

    // Internal wires for addition/subtraction
    wire signed [9:0] pr_shifted;
    wire signed [9:0] pr_next_add;
    wire signed [9:0] pr_next_sub;

    // Determine partial remainder (upper 9 bits of SR)
    assign pr = $signed(SR[16:8]);
    assign divisor_s = $signed(divisor_abs);

    // On each iteration, shift left by 1 (drop top bit?), then add or subtract divisor based on sign of pr

    // Because we shift left SR by 1, partial remainder and quotient move accordingly:
    // We'll do shifting inside the always block

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

                        // Extend divisor to 9 bits (9th bit = 0)
                        divisor_abs <= {1'b0, divisor_val};

                        // Initialize SR:
                        // Partial remainder = dividend_abs shifted left by 1 (for 9 bits)
                        // Quotient bits = 0
                        SR <= {dividend_abs, 1'b0, 8'd0}; // {9 bits PR, 8 bits Q} = {dividend_abs[7:0], 1'b0, 8'd0}

                        cnt <= 4'd0;
                        state <= RUN;
                    end else begin
                        state <= IDLE;
                    end
                end
                RUN: begin
                    // At each iteration:
                    // 1) Shift SR left by 1 bit
                    // 2) Add or subtract divisor_abs to partial remainder based on previous sign of PR

                    // Shift left SR by 1: {PR[8:0], Q[7:0]} << 1
                    // After shift left by 1:
                    // New partial remainder = (PR << 1) + SR[7] (old Q's MSB)
                    // New quotient = Q shifted left by 1, last bit to be set by next quotient bit

                    // Extract bits
                    // current partial remainder: SR[16:8] (9 bits)
                    // current quotient: SR[7:0] (8 bits)
                    // shifting left by 1 means:
                    // PR_shifted = (PR << 1) | Q[7]
                    // Quotient shifted left by 1, new bit to be set below

                    // Prepare shifted partial remainder with Q[7] bit included
                    reg signed [9:0] pr_shifted_tmp;
                    pr_shifted_tmp = {SR[16:8], 1'b0}; // shift left by 1: shift PR left by 1, LSB zeroed
                    pr_shifted_tmp = pr_shifted_tmp | {9'd0, SR[7]}; // insert old Q's MSB into LSB of PR

                    // Next partial remainder and quotient bit depend on sign of previous PR:
                    // If PR >= 0, subtract divisor
                    // Else, add divisor
                    reg signed [9:0] pr_next;
                    reg next_qbit;

                    if (pr >= 0) begin
                        pr_next = pr_shifted_tmp - $signed(divisor_abs);
                    end else begin
                        pr_next = pr_shifted_tmp + $signed(divisor_abs);
                    end

                    next_qbit = ~(pr_next[9]); // if PR_next >= 0, Q_bit=1; else Q_bit=0

                    // Compose new SR:
                    // SR[16:8] = pr_next[8:0]
                    // SR[7:0] = (Q << 1) | next_qbit
                    SR <= {pr_next[8:0], SR[7:0] << 1 | next_qbit};

                    cnt <= cnt + 1'b1;
                    if (cnt == 4'd7) begin
                        state <= FINISH;
                    end else begin
                        state <= RUN;
                    end
                end
                FINISH: begin
                    // Final correction if partial remainder negative: add divisor back
                    reg signed [9:0] pr_final;
                    pr_final = $signed(SR[16:8]);
                    reg [16:0] SR_final;
                    if (pr_final < 0) begin
                        pr_final = pr_final + $signed(divisor_abs);
                    end
                    SR_final = {pr_final[8:0], SR[7:0]};
                    SR <= SR_final;

                    // Sign correction for quotient and remainder
                    reg [7:0] quotient_raw;
                    reg [7:0] remainder_raw;
                    reg [7:0] quotient_corr;
                    reg [7:0] remainder_corr;

                    quotient_raw = SR_final[7:0];
                    remainder_raw = SR_final[16:9]; // upper 8 bits of PR

                    if (sign) begin
                        // Quotient correction
                        if (quotient_neg)
                            quotient_corr = (~quotient_raw) + 1'b1;
                        else
                            quotient_corr = quotient_raw;

                        // Remainder correction
                        if (remainder_neg)
                            remainder_corr = (~remainder_raw) + 1'b1;
                        else
                            remainder_corr = remainder_raw;
                    end else begin
                        quotient_corr = quotient_raw;
                        remainder_corr = remainder_raw;
                    end

                    result <= {remainder_corr, quotient_corr};
                    res_valid <= 1'b1;

                    cnt <= 4'd0;
                    state <= IDLE; // ready for next operation
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule