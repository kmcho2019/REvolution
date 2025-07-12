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

    // State machine states
    localparam IDLE   = 2'd0;
    localparam RUN    = 2'd1;
    localparam FINISH = 2'd2;

    reg [1:0] state, next_state;

    // Counter for 8 iterations
    reg [3:0] cnt, cnt_next;

    // Registers to hold operands and signs
    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // Shift Register SR: {partial_remainder[8:0], quotient[7:0]} = 17 bits total
    reg [16:0] SR, SR_next;

    // Wires for partial remainder and quotient extraction
    wire signed [9:0] pr_current;    // extended partial remainder (sign-extended 9 bits to 10)
    wire signed [9:0] divisor_ext;   // divisor extended to 10 bits (sign-extended)

    // Partial remainder current value
    assign pr_current = {SR[16], SR[16:8]}; // sign-extend SR[16:8] to 10 bits

    // divisor_ext: sign-extended divisor_abs (9 bits zero extended to 10 bits)
    assign divisor_ext = {1'b0, divisor_abs}; // divisor_abs is 8 bits zero-extended to 9 bits in IDLE, use 10-bit signed here by zero-extend MSB

    // Next partial remainder and quotient bit computed combinationally for RUN state
    reg signed [9:0] pr_shifted; // partial remainder shifted left by 1 + current Q MSB
    reg signed [9:0] pr_next;    // partial remainder next value after add/subtract divisor
    reg q_bit_next;

    // Current quotient
    wire [7:0] quotient_current = SR[7:0];
    wire q_msb = quotient_current[7];

    // Compute pr_shifted combinationally
    always @(*) begin
        // Shift partial remainder left by 1 and insert current quotient MSB into LSB of partial remainder
        pr_shifted = (pr_current <<< 1) | {9'd0, q_msb};
    end

    // Compute pr_next based on sign of pr_current
    always @(*) begin
        if (pr_current >= 0)
            pr_next = pr_shifted - divisor_ext;
        else
            pr_next = pr_shifted + divisor_ext;
    end

    // Next quotient bit: 1 if pr_next >=0 else 0 (next_qbit = ~pr_next[9])
    always @(*) begin
        q_bit_next = ~pr_next[9];
    end

    // FSM next state logic and registers update
    always @(*) begin
        // Defaults
        next_state = state;
        cnt_next = cnt;
        SR_next = SR;
        res_valid = 1'b0;
        result = result; // Hold previous value unless updated below

        case(state)
            IDLE: begin
                if (opn_valid) begin
                    next_state = RUN;
                    cnt_next = 0;

                    // On opn_valid, inputs captured and signs/abs calculated in sequential block below
                    // SR_next set in sequential block as well
                end else begin
                    next_state = IDLE;
                end
            end

            RUN: begin
                if (cnt == 4'd7) begin
                    next_state = FINISH;
                end else begin
                    next_state = RUN;
                    cnt_next = cnt + 1;
                end

                // SR_next updated in sequential block below using pr_next and q_bit_next
            end

            FINISH: begin
                next_state = IDLE;
                res_valid = 1'b1;
                // result updated in sequential block below after sign correction
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic block
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            cnt <= 4'd0;
            SR <= 17'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;
            res_valid <= 1'b0;
            result <= 16'd0;
        end else begin
            state <= next_state;
            cnt <= cnt_next;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Capture input signs and compute abs values
                        if (sign && dividend[7]) begin
                            dividend_neg <= 1'b1;
                            dividend_abs <= (~dividend) + 1'b1;
                        end else begin
                            dividend_neg <= 1'b0;
                            dividend_abs <= dividend;
                        end

                        if (sign && divisor[7]) begin
                            divisor_neg <= 1'b1;
                            divisor_abs <= (~divisor) + 1'b1;
                        end else begin
                            divisor_neg <= 1'b0;
                            divisor_abs <= divisor;
                        end

                        // Determine quotient and remainder sign
                        quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                        remainder_neg <= (sign && dividend[7]);

                        // Initialize SR: partial remainder = dividend_abs shifted left by 1 (9 bits), quotient = 0
                        // SR: {PR[8:0], Q[7:0]}
                        SR <= {dividend_abs, 1'b0, 8'd0};
                    end else begin
                        // Maintain SR
                        SR <= SR;
                    end
                end

                RUN: begin
                    // Update SR based on pr_next and next quotient bit
                    // SR_next = {pr_next[8:0], quotient<<1 | q_bit_next}
                    SR <= {pr_next[8:0], (quotient_current << 1) | q_bit_next};
                end

                FINISH: begin
                    // Final partial remainder
                    reg signed [9:0] pr_final;
                    pr_final = {SR[16], SR[16:8]};

                    // Add divisor back if pr_final negative
                    if (pr_final < 0)
                        pr_final = pr_final + divisor_ext;

                    // Compose corrected SR with fixed partial remainder and unchanged quotient
                    SR <= {pr_final[8:0], SR[7:0]};

                    // Extract raw quotient and remainder
                    reg [7:0] quotient_raw;
                    reg [7:0] remainder_raw;
                    quotient_raw = SR[7:0];
                    remainder_raw = SR[16:9]; // upper 8 bits of partial remainder

                    // Apply sign corrections
                    reg [7:0] quotient_corr;
                    reg [7:0] remainder_corr;

                    if (sign) begin
                        quotient_corr = quotient_neg ? (~quotient_raw + 1'b1) : quotient_raw;
                        remainder_corr = remainder_neg ? (~remainder_raw + 1'b1) : remainder_raw;
                    end else begin
                        quotient_corr = quotient_raw;
                        remainder_corr = remainder_raw;
                    end

                    // Output result: {remainder[7:0], quotient[7:0]}
                    result <= {remainder_corr, quotient_corr};

                    res_valid <= 1'b1;
                end

                default: begin
                    // Do nothing
                end
            endcase
        end
    end

endmodule