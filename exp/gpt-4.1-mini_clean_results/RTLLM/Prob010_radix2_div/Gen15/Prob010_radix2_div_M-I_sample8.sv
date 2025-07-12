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

    // FSM states as localparam
    localparam IDLE   = 2'd0;
    localparam RUN    = 2'd1;
    localparam FINISH = 2'd2;

    reg [1:0] state, next_state;

    reg [3:0] cnt;          // iteration counter: counts 0..8
    reg [16:0] SR;          // shift register: {partial_remainder[8:0], quotient[7:0]}
    reg [8:0] divisor_abs;  // absolute value of divisor extended to 9 bits

    // Registers to hold absolute values and sign flags
    reg [7:0] dividend_abs;
    reg [7:0] divisor_val;
    reg dividend_neg;
    reg divisor_neg;
    reg quotient_neg;
    reg remainder_neg;

    // Signed partial remainder signals (9 bits signed extended to 10 bits for operations)
    wire signed [9:0] pr;          // partial remainder signed (from SR[16:8])
    wire signed [9:0] pr_shifted;  // partial remainder shifted left by 1 and concatenated with quotient MSB
    wire signed [9:0] divisor_s;   // divisor signed extended to 10 bits
    wire signed [9:0] pr_next;     // next partial remainder after add/subtract divisor
    wire next_qbit;                // next quotient bit

    assign pr = $signed({SR[16], SR[16:8]}); // Sign-extend 9 bits to 10 bits: SR[16:8], SR[16] is sign bit
    assign divisor_s = $signed({1'b0, divisor_abs}); // 9 bits zero-extend to 10 bits signed (positive)

    // Shift partial remainder left by 1 bit and insert quotient MSB (SR[7]) as LSB
    assign pr_shifted = {pr[8:0], SR[7]};

    // If partial remainder >= 0: pr_next = pr_shifted - divisor_s
    // Else pr_next = pr_shifted + divisor_s
    assign pr_next = (pr >= 0) ? (pr_shifted - divisor_s) : (pr_shifted + divisor_s);

    // Next quotient bit = 1 if pr_next >= 0 else 0
    assign next_qbit = ~pr_next[9]; // pr_next[9] is sign bit, so 0 => positive

    // FSM sequential: state, cnt, SR, signs and absolute values
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            cnt <= 4'd0;
            SR <= 17'd0;
            res_valid <= 1'b0;
            result <= 16'd0;
            dividend_abs <= 8'd0;
            divisor_val <= 8'd0;
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
                        // Capture inputs, compute absolute values
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

                        divisor_abs <= {1'b0, divisor_val};

                        // Initialize SR with partial remainder = dividend_abs << 1 (9 bits) and quotient = 0
                        // Layout: SR[16:8] = partial remainder (9 bits), SR[7:0] = quotient (8 bits)
                        SR <= {dividend_abs, 1'b0, 8'd0}; // {dividend_abs[7:0], 1'b0, 8'd0} total 17 bits

                        cnt <= 4'd0;
                    end
                end

                RUN: begin
                    // Each iteration update SR and increment counter
                    // SR = {pr_next[8:0], (SR[7:0] << 1) | next_qbit}
                    SR <= {pr_next[8:0], (SR[7:0] << 1) | next_qbit};
                    cnt <= cnt + 1'b1;
                end

                FINISH: begin
                    // Apply final correction if partial remainder negative (add divisor_abs)
                    // Then sign-correct quotient and remainder accordingly

                    reg signed [9:0] pr_final;
                    reg [16:0] SR_final;
                    reg [7:0] quotient_raw;
                    reg [7:0] remainder_raw;
                    reg [7:0] quotient_corr;
                    reg [7:0] remainder_corr;

                    pr_final = $signed({SR[16], SR[16:8]});
                    if (pr_final < 0)
                        pr_final = pr_final + $signed(divisor_abs);

                    SR_final = {pr_final[8:0], SR[7:0]};
                    SR <= SR_final;

                    quotient_raw = SR_final[7:0];
                    remainder_raw = SR_final[16:9]; // upper 8 bits as remainder

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
                end

                default: ;
            endcase
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (opn_valid)
                    next_state = RUN;
                else
                    next_state = IDLE;
            end
            RUN: begin
                if (cnt == 4'd7) // Completed 8 iterations after 0..7
                    next_state = FINISH;
                else
                    next_state = RUN;
            end
            FINISH: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule