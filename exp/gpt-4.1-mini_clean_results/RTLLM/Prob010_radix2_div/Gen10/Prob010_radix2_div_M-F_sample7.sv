module radix2_div (
    input            clk,
    input            rst,
    input            sign,
    input      [7:0] dividend,
    input      [7:0] divisor,
    input            opn_valid,
    output reg       res_valid,
    output reg [15:0] result
);

    // FSM states
    localparam IDLE = 1'b0, RUN = 1'b1;
    reg state, next_state;

    // Internal registers
    reg [8:0] divisor_abs;      // Absolute divisor, 9 bits (to handle negation)
    reg [8:0] neg_divisor;      // -divisor_abs in 9 bits
    reg [16:0] SR;              // Shift register: remainder(9 bits) + quotient(8 bits)
    reg [3:0] cnt;              // Division step counter 1 to 8

    reg dividend_sign, divisor_sign;
    reg quotient_sign, remainder_sign;

    // Registers for final quotient and remainder sign correction
    reg [7:0] quotient_unsigned;
    reg [7:0] remainder_unsigned;
    reg [7:0] quotient_final;
    reg [7:0] remainder_final;

    // Wires for subtraction
    wire [8:0] rem_before_sub = SR[16:8]; // current remainder upper 9 bits
    wire [9:0] rem_sub;                    // 10-bit subtraction result
    wire rem_sub_neg;                      // indicates negative result if 1

    // Functions

    // Compute absolute value with sign support
    function [8:0] abs9;
        input [7:0] val;
        input       sign_bit;
        begin
            if (sign_bit && val[7])       // negative number with sign enabled
                abs9 = {1'b0, (~val) + 8'd1};
            else
                abs9 = {1'b0, val};
        end
    endfunction

    // 9-bit two's complement negation
    function [8:0] neg9;
        input [8:0] val;
        begin
            neg9 = (~val) + 9'd1;
        end
    endfunction

    // Subtraction remainder - divisor_abs
    assign rem_sub = {1'b0, rem_before_sub} + neg_divisor; // 10 bits
    assign rem_sub_neg = rem_sub[9]; // MSB indicates negative

    // FSM combinational next state
    always @(*) begin
        case(state)
            IDLE:
                if (opn_valid && !res_valid)
                    next_state = RUN;
                else
                    next_state = IDLE;
            RUN:
                if (cnt == 4'd8)
                    next_state = IDLE;
                else
                    next_state = RUN;
            default:
                next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state          <= IDLE;
            res_valid      <= 1'b0;
            result         <= 16'd0;
            SR             <= 17'd0;
            cnt            <= 4'd0;
            divisor_abs    <= 9'd0;
            neg_divisor    <= 9'd0;
            dividend_sign  <= 1'b0;
            divisor_sign   <= 1'b0;
            quotient_sign  <= 1'b0;
            remainder_sign <= 1'b0;
            quotient_unsigned <= 8'd0;
            remainder_unsigned <= 8'd0;
            quotient_final <= 8'd0;
            remainder_final <= 8'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    cnt       <= 4'd0;

                    if (opn_valid && !res_valid) begin
                        // Capture sign bits
                        dividend_sign <= (sign) ? dividend[7] : 1'b0;
                        divisor_sign  <= (sign) ? divisor[7] : 1'b0;

                        quotient_sign  <= (sign) ? (dividend[7] ^ divisor[7]) : 1'b0;
                        remainder_sign <= (sign) ? dividend[7] : 1'b0;

                        // Calculate absolute values
                        divisor_abs <= abs9(divisor, sign);
                        neg_divisor <= neg9(abs9(divisor, sign));

                        // Initialize shift register: remainder zero + dividend_abs quotient
                        SR <= {9'd0, abs9(dividend, sign)[7:0]};

                        res_valid <= 1'b0;
                    end else if (res_valid && opn_valid) begin
                        // If result consumed and new op requested, clear res_valid
                        res_valid <= 1'b0;
                    end
                end

                RUN: begin
                    cnt <= cnt + 1'b1;

                    // Shift left SR by 1 (shift quotient and remainder)
                    // We will update SR with either subtraction result or restore remainder next

                    SR <= {SR[15:0], 1'b0};
                end
            endcase

            // Perform division step at RUN state but starting from cnt=1
            if (state == RUN && cnt >= 1 && cnt <= 8) begin
                if (!rem_sub_neg) begin
                    // Subtraction succeeded, update remainder and set quotient bit
                    // SR after shift is {remainder[15:8], quotient[7:1], 0}
                    // We update remainder bits [16:8] = rem_sub[8:0]
                    // Update quotient LSB = 1

                    SR <= {rem_sub[8:0], SR[7:1], 1'b1};
                end else begin
                    // Subtraction failed, restore remainder (undo subtraction)
                    // Quotient LSB remains 0 (already 0 after shift)
                    // Restore remainder bits with remainder before subtraction (rem_before_sub)
                    SR <= {rem_before_sub, SR[7:1], 1'b0};
                end

                // At last step, extract quotient and remainder for sign correction
                if (cnt == 4'd8) begin
                    quotient_unsigned <= SR[7:0];
                    remainder_unsigned <= SR[16:9];
                end
            end

            // On transition from RUN to IDLE (division done), output result with sign correction
            if (state == RUN && next_state == IDLE && cnt == 4'd8) begin
                // Sign correction for quotient
                if (sign && quotient_sign)
                    quotient_final <= (~quotient_unsigned) + 8'd1;
                else
                    quotient_final <= quotient_unsigned;

                // Sign correction for remainder
                if (sign && remainder_sign)
                    remainder_final <= (~remainder_unsigned) + 8'd1;
                else
                    remainder_final <= remainder_unsigned;

                res_valid <= 1'b1;
            end

            // Output result at IDLE state after RUN completes
            if (state == IDLE && res_valid) begin
                result <= {remainder_final, quotient_final};
            end
        end
    end

endmodule