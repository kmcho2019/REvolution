module radix2_div (
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result
);

    // State encoding
    localparam IDLE   = 2'd0;
    localparam DIVIDE = 2'd1;
    localparam DONE   = 2'd2;

    reg [1:0] state, next_state;

    // Internal registers
    // Shift register: 18-bit: [17:9] remainder(9 bits), [8:1] quotient(8 bits), [0] shifted in bit
    reg [17:0] SR, SR_next;

    // Counter from 0 to 8 steps
    reg [3:0] cnt, cnt_next;

    // Registers for absolute values and sign flags
    reg [7:0] dividend_abs, divisor_abs;
    reg       dividend_neg, divisor_neg, quotient_neg, remainder_neg;

    // Extended divisor: 9-bit for subtraction with remainder
    reg [8:0] divisor_ext;
    reg [8:0] neg_divisor;

    // Subtraction wires
    wire [8:0] remainder = SR[17:9];
    wire [9:0] sub_res;   // 10-bit result for borrow detection
    wire       sub_success;

    // Raw quotient and remainder from SR after division
    wire [7:0] raw_quotient = SR[8:1];
    wire [7:0] raw_remainder = SR[17:10];

    // Corrected quotient and remainder after sign fix
    reg [7:0] corrected_quotient;
    reg [7:0] corrected_remainder;

    //
    // Synchronous state, counter, and registers update
    //
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            cnt          <= 4'd0;
            SR           <= 18'd0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
            divisor_ext  <= 9'd0;
            neg_divisor  <= 9'd0;
            res_valid    <= 1'b0;
            result       <= 16'd0;
        end else begin
            state        <= next_state;
            cnt          <= cnt_next;
            SR           <= SR_next;

            // Latch absolute values and signs at IDLE start
            if (state == IDLE && opn_valid) begin
                // dividend absolute and sign
                if(sign && dividend[7]) begin
                    dividend_abs <= (~dividend) + 8'd1;
                    dividend_neg <= 1'b1;
                end else begin
                    dividend_abs <= dividend;
                    dividend_neg <= 1'b0;
                end

                // divisor absolute and sign
                if(sign && divisor[7]) begin
                    divisor_abs <= (~divisor) + 8'd1;
                    divisor_neg <= 1'b1;
                end else begin
                    divisor_abs <= divisor;
                    divisor_neg <= 1'b0;
                end

                // Quotient sign = dividend sign xor divisor sign
                quotient_neg <= sign && (dividend[7] ^ divisor[7]);
                remainder_neg <= sign && dividend[7];
            end

            // Initialize shift register and divisor_ext at IDLE start
            if(state == IDLE && opn_valid) begin
                // SR format:
                // remainder (9 bits) = 0
                // quotient (8 bits) = dividend_abs shifted left by 1 (lowest bit zero)
                // low bit zero for shift
                SR <= {9'd0, dividend_abs, 1'b0};

                // divisor extended to 9 bits for subtraction
                divisor_ext <= {1'b0, divisor_abs};
                // negated divisor for subtraction (two's complement)
                neg_divisor <= ~{1'b0, divisor_abs} + 9'd1;

                cnt <= 4'd0;
            end

            // When done, latch result with sign correction
            if(state == DONE && !res_valid) begin
                // Sign-correct quotient
                if(quotient_neg)
                    corrected_quotient <= (~raw_quotient) + 8'd1;
                else
                    corrected_quotient <= raw_quotient;

                // Sign-correct remainder
                if(remainder_neg)
                    corrected_remainder <= (~raw_remainder) + 8'd1;
                else
                    corrected_remainder <= raw_remainder;

                // Assign result
                result <= {corrected_remainder, corrected_quotient};
                res_valid <= 1'b1;
            end

            // Clear res_valid when starting new operation
            if(state == IDLE && opn_valid)
                res_valid <= 1'b0;

            // Clear res_valid if IDLE without opn_valid (ready for next)
            if(state == IDLE && !opn_valid)
                res_valid <= 1'b0;
        end
    end

    //
    // Combinational next state logic and counter update
    //
    always @(*) begin
        // Defaults
        next_state = state;
        cnt_next = cnt;
        SR_next = SR;

        case(state)
            IDLE: begin
                if(opn_valid)
                    next_state = DIVIDE;
            end

            DIVIDE: begin
                if(cnt == 4'd8) begin
                    next_state = DONE;
                end else begin
                    next_state = DIVIDE;
                    cnt_next = cnt + 1'b1;

                    // Try subtraction remainder - divisor
                    if(sub_success) begin
                        // Update remainder bits with subtraction result
                        // Insert quotient bit = 1 (LSB after shift)
                        SR_next[17:9] = sub_res[8:0];
                        SR_next = (SR << 1) | 18'd1; // Shift left + quotient bit 1
                    end else begin
                        // Subtraction failed: remainder unchanged, quotient bit = 0
                        SR_next = (SR << 1);
                    end
                end
            end

            DONE: begin
                // Wait here until new operation starts
                if(opn_valid)
                    next_state = DIVIDE;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    //
    // Subtraction for division step: remainder - divisor_ext
    //
    assign sub_res = {1'b0, remainder} + {1'b0, neg_divisor};
    assign sub_success = ~sub_res[9];  // borrow flag: 0 means no borrow = success

endmodule