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
        IDLE = 2'd0,
        CALC = 2'd1,
        DONE = 2'd2
    } state_t;

    state_t state, next_state;

    reg [3:0] cnt; // counts from 0 to 8 for 8 steps

    // Sign info and absolute values
    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;
    reg [7:0] dividend_abs, divisor_abs;

    // Shift register: {partial_remainder[8:0], quotient[7:0]} 17 bits total
    reg [16:0] SR;

    // Extract fields
    wire signed [8:0] partial_remainder = SR[16:8];
    wire [7:0] quotient = SR[7:0];

    // Subtraction operand: divisor_abs zero-extended to 9 bits
    wire signed [8:0] divisor_ext = {1'b0, divisor_abs};

    // Compute trial subtraction: partial_remainder - divisor_abs
    wire signed [9:0] trial_sub = {partial_remainder[8], partial_remainder} - {1'b0, divisor_ext};

    // Next quotient bit = 1 if trial_sub >= 0
    wire next_quot_bit = ~trial_sub[9];

    // Next partial remainder after subtraction if trial_sub >= 0, else partial_remainder shifted left
    wire [8:0] next_partial_remainder = next_quot_bit ? trial_sub[8:0] : {partial_remainder[7:0], 1'b0};

    // Next quotient shifted left by 1 and OR in next_quot_bit
    wire [7:0] next_quotient = {quotient[6:0], next_quot_bit};

    // Internal signals to hold sign-corrected outputs
    reg [7:0] quotient_signed;
    reg [7:0] remainder_signed;

    // FSM: next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = (opn_valid) ? CALC : IDLE;
            CALC: next_state = (cnt == 4'd8) ? DONE : CALC;
            DONE: next_state = (res_valid && !opn_valid) ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential FSM and registers
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            cnt <= 4'd0;
            res_valid <= 1'b0;
            result <= 16'd0;
            SR <= 17'd0;
            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
            quotient_signed <= 8'd0;
            remainder_signed <= 8'd0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    if (opn_valid) begin
                        // Capture sign flags
                        dividend_neg <= sign & dividend[7];
                        divisor_neg <= sign & divisor[7];
                        // Abs values
                        dividend_abs <= (sign & dividend[7]) ? (~dividend + 1) : dividend;
                        divisor_abs <= (sign & divisor[7]) ? (~divisor + 1) : divisor;
                        // Determine quotient and remainder sign
                        quotient_neg <= sign & (dividend[7] ^ divisor[7]);
                        remainder_neg <= sign & dividend[7];
                        // Initialize SR: partial remainder = dividend_abs shifted left by 1, quotient = 0
                        // partial remainder is 9 bits: {dividend_abs, 1'b0}
                        SR <= {dividend_abs, 1'b0, 8'd0};
                    end
                end

                CALC: begin
                    cnt <= cnt + 1;
                    // Update SR with next partial remainder and quotient
                    SR <= {next_partial_remainder, next_quotient};
                end

                DONE: begin
                    // After final iteration (cnt==8), result is valid
                    res_valid <= 1'b1;

                    // Apply sign correction to quotient
                    if (quotient_neg)
                        quotient_signed <= (~SR[7:0] + 1);
                    else
                        quotient_signed <= SR[7:0];

                    // Apply sign correction to remainder (partial remainder is bits 16:8)
                    // remainder is 9 bits; take upper 8 bits with sign extension
                    // We only output 8-bit remainder, as specified
                    if (remainder_neg) begin
                        // remainder is sign-extended 8 bits, so truncate bits[16:9]
                        remainder_signed <= (~SR[16:9] + 1);
                    end else begin
                        remainder_signed <= SR[16:9];
                    end

                    // Pack output
                    result <= {remainder_signed, quotient_signed};
                end

                default: begin
                    // Default no change
                end
            endcase
        end
    end

endmodule