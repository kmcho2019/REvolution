module radix2_div (
    input             clk,
    input             rst,
    input             sign,
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    input             res_ready,
    output reg        res_valid,
    output reg [15:0] result
);

    // FSM States
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        RUN  = 2'b01,
        DONE = 2'b10
    } state_t;

    state_t state, next_state;

    // Internal registers
    reg [7:0] dividend_abs, divisor_abs;
    reg       dividend_neg, divisor_neg;
    reg       quotient_neg, remainder_neg;

    reg [8:0] remainder;    // 9 bits to hold remainder including sign bit for subtraction
    reg [7:0] quotient;
    reg [3:0] bit_cnt;

    // Signals for subtraction and decision
    wire signed [9:0] rem_sub; // 10 bits signed for subtraction (remainder - divisor)
    reg signed [9:0] remainder_signed;

    // Helper function to get absolute value of 8-bit number with sign flag
    function [7:0] abs8;
        input [7:0] val;
        begin
            if (sign && val[7])
                abs8 = (~val) + 8'd1;
            else
                abs8 = val;
        end
    endfunction

    // Helper function to negate 8-bit number (two's complement)
    function [7:0] negate8;
        input [7:0] val;
        begin
            negate8 = (~val) + 8'd1;
        end
    endfunction

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (opn_valid && !res_valid)
                    next_state = RUN;
                else
                    next_state = IDLE;
            end
            RUN: begin
                if (bit_cnt == 4'd8)
                    next_state = DONE;
                else
                    next_state = RUN;
            end
            DONE: begin
                if (res_ready)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Main sequential block
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            remainder    <= 9'd0;
            quotient     <= 8'd0;
            bit_cnt      <= 4'd0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    bit_cnt <= 4'd0;
                    remainder <= 9'd0;
                    quotient <= 8'd0;
                    if (opn_valid && !res_valid) begin
                        // Capture absolute values
                        dividend_abs <= abs8(dividend);
                        divisor_abs  <= abs8(divisor);

                        dividend_neg <= (sign) ? dividend[7] : 1'b0;
                        divisor_neg  <= (sign) ? divisor[7] : 1'b0;

                        quotient_neg  <= (sign) ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_neg <= (sign) ? dividend[7] : 1'b0;

                        // Load quotient with dividend_abs initially
                        quotient <= abs8(dividend);

                        // Reset remainder to 0 for starting division
                        remainder <= 9'd0;
                    end
                end

                RUN: begin
                    // Shift left remainder and bring in MSB of quotient into LSB of remainder
                    remainder <= {remainder[7:0], quotient[7]};
                    quotient <= {quotient[6:0], 1'b0}; // Shift left quotient

                    // Compute remainder - divisor_abs
                    remainder_signed = {1'b0, remainder} - {1'b0, divisor_abs};

                    if (!remainder_signed[9]) begin
                        // remainder >= 0 after subtraction: update remainder and set quotient LSB = 1
                        remainder <= remainder_signed[8:0];
                        quotient[0] <= 1'b1;
                    end else begin
                        // remainder < 0: restore remainder, quotient LSB = 0 (already zero by shift)
                        // remainder unchanged (already shifted in)
                    end

                    bit_cnt <= bit_cnt + 1'b1;
                end

                DONE: begin
                    // Apply sign corrections before outputting result
                    reg [7:0] quotient_signed, remainder_signed_out;

                    // Quotient sign correction
                    if (quotient_neg)
                        quotient_signed = negate8(quotient);
                    else
                        quotient_signed = quotient;

                    // Remainder sign correction
                    if (remainder_neg)
                        remainder_signed_out = negate8(remainder[7:0]);
                    else
                        remainder_signed_out = remainder[7:0];

                    result <= {remainder_signed_out, quotient_signed};
                    res_valid <= 1'b1;

                    if (res_ready) begin
                        res_valid <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule