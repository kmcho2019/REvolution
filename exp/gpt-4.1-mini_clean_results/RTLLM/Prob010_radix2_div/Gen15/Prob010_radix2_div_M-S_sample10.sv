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
    localparam IDLE   = 2'd0;
    localparam DIVIDE = 2'd1;
    localparam DONE   = 2'd2;

    reg [1:0] state, next_state;

    reg [3:0] cnt, cnt_next;

    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // Shift register: {partial_remainder[8:0], quotient[7:0]} = 17 bits
    reg [16:0] SR, SR_next;

    // Internal signals for subtraction and addition
    reg signed [9:0] partial_rem;    // 9 bits partial remainder with sign extension (10 bits)
    reg signed [9:0] divisor_ext;    // divisor extended to signed 10 bits

    reg signed [9:0] diff;

    // next quotient bit
    reg qbit;

    integer i;

    // State and counter updates combinational
    always @(*) begin
        next_state = state;
        cnt_next = cnt;
        SR_next = SR;
        res_valid = 1'b0;
        result = result;

        case(state)
            IDLE: begin
                if (opn_valid) begin
                    next_state = DIVIDE;
                    cnt_next = 0;
                end
            end

            DIVIDE: begin
                if (cnt == 4'd7)
                    next_state = DONE;
                else
                    cnt_next = cnt + 1;

                // Extract current partial remainder (bits 16:8) with sign extension
                partial_rem = {SR[16], SR[16:8]}; // 9 bits sign extended to 10 bits
                divisor_ext = {1'b0, divisor_abs}; // unsigned 8 bits zero-extended to 9 bits + 1 extra bit zero (10 bits)
                // For signed, divisor_abs is positive

                // Shift partial remainder left by 1, bring in quotient MSB at LSB of partial remainder
                partial_rem = (partial_rem << 1) | SR[7];

                // Subtract divisor_abs
                diff = partial_rem - divisor_ext;

                // Decide quotient bit and next partial remainder
                if (diff[9] == 0) begin
                    qbit = 1'b1;
                    partial_rem = diff;
                end else begin
                    qbit = 1'b0;
                    // partial_rem unchanged (since subtraction was negative)
                end

                // Build next SR: partial_rem[8:0] + quotient shifted left 1 + qbit
                SR_next = {partial_rem[8:0], (SR[7:0] << 1) | qbit};
            end

            DONE: begin
                // Final correction: if partial remainder negative, add divisor back
                partial_rem = {SR[16], SR[16:8]};
                divisor_ext = {1'b0, divisor_abs};

                if (partial_rem[9] == 1'b1)
                    partial_rem = partial_rem + divisor_ext;

                // Compose SR with corrected remainder and quotient
                SR_next = {partial_rem[8:0], SR[7:0]};

                // Extract raw quotient and remainder
                // remainder is upper 8 bits of partial remainder, quotient is lower 8 bits
                // Apply sign correction below in sequential block

                next_state = IDLE;
                res_valid = 1'b1;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            cnt <= 4'd0;
            SR <= 17'd0;
            dividend_neg <= 0;
            divisor_neg <= 0;
            quotient_neg <= 0;
            remainder_neg <= 0;
            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;
            res_valid <= 1'b0;
            result <= 16'd0;
        end else begin
            state <= next_state;
            cnt <= cnt_next;
            SR <= SR_next;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Handle signed or unsigned absolute values
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

                        quotient_neg <= sign && (dividend[7] ^ divisor[7]);
                        remainder_neg <= sign && dividend[7];

                        // Initialize shift register:
                        // partial remainder = dividend_abs (9 bits with 0 MSB), quotient = 0
                        // Partial remainder occupies bits 16:8 (9 bits), quotient bits 7:0
                        // Append 1 zero bit LSB of partial remainder to simplify shift
                        SR <= {1'b0, dividend_abs, 8'd0};
                    end
                end

                DONE: begin
                    // Extract raw quotient and remainder from SR_next (already corrected)
                    reg [7:0] quotient_raw;
                    reg [7:0] remainder_raw;
                    reg [7:0] quotient_corr;
                    reg [7:0] remainder_corr;

                    quotient_raw = SR_next[7:0];
                    remainder_raw = SR_next[16:9]; // upper 8 bits of corrected partial remainder

                    if (sign) begin
                        quotient_corr = quotient_neg ? (~quotient_raw + 1'b1) : quotient_raw;
                        remainder_corr = remainder_neg ? (~remainder_raw + 1'b1) : remainder_raw;
                    end else begin
                        quotient_corr = quotient_raw;
                        remainder_corr = remainder_raw;
                    end

                    result <= {remainder_corr, quotient_corr};
                    res_valid <= 1'b1;
                end

                default: begin
                    res_valid <= 1'b0;
                end
            endcase
        end
    end

endmodule