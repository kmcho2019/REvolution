module radix2_div (
    input             clk,
    input             rst,
    input             sign,          // 1: signed division, 0: unsigned
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result          // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    localparam IDLE    = 2'd0;
    localparam RUNNING = 2'd1;
    localparam DONE    = 2'd2;

    reg [1:0] state, next_state;

    // Internal signals for sign handling
    reg dividend_neg, divisor_neg;

    // Absolute values of dividend and divisor
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;

    // 17-bit shift register: [16:8] remainder (9 bits), [7:0] quotient (8 bits)
    reg [16:0] SR;

    // Division cycle counter (1 to 8)
    reg [3:0] cnt;

    // Wires for subtraction
    wire [8:0] remainder_part = SR[16:8];
    wire [8:0] sub_res;
    wire       borrow; // borrow=1 if subtraction underflow

    // Perform subtraction: remainder - divisor
    assign {borrow, sub_res} = {1'b0, remainder_part} - {1'b0, abs_divisor};

    // State transition logic
    always @(*) begin
        case(state)
            IDLE:
                if (opn_valid)
                    next_state = RUNNING;
                else
                    next_state = IDLE;
            RUNNING:
                if (cnt == 4'd8)
                    next_state = DONE;
                else
                    next_state = RUNNING;
            DONE:
                if (opn_valid)
                    next_state = RUNNING;
                else
                    next_state = IDLE;
            default:
                next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            cnt          <= 4'd0;
            SR           <= 17'd0;
            abs_dividend <= 8'd0;
            abs_divisor  <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt       <= 4'd0;
                    if (opn_valid) begin
                        // Capture sign and absolute values
                        dividend_neg <= sign & dividend[7];
                        divisor_neg  <= sign & divisor[7];

                        abs_dividend <= (sign & dividend[7]) ? (~dividend + 1'b1) : dividend;
                        abs_divisor  <= (sign & divisor[7]) ? (~divisor + 1'b1)  : divisor;

                        // Initialize shift register: remainder=0, quotient=abs_dividend
                        // Format SR = {remainder[8:0], quotient[7:0]} = {9'd0, abs_dividend}
                        SR <= {9'd0, (sign & dividend[7]) ? (~dividend + 1'b1) : dividend};
                        cnt <= 4'd0;
                    end
                end

                RUNNING: begin
                    cnt <= cnt + 1'b1;

                    // Shift SR left by 1 bit:
                    // SR[16:0] <<= 1, then if subtraction succeeds, replace remainder part with sub_res and set quotient LSB to 1
                    // else keep remainder part unchanged and set quotient LSB to 0.

                    if (~borrow) begin
                        // subtraction successful: update remainder to sub_res and shift in quotient bit = 1
                        SR <= {sub_res[7:0], SR[7:0], 1'b1} << 1;
                        // However, this is slightly incorrect because shifting the entire 17-bit register left by 1,
                        // then setting LSB to 1 would be:
                        // SR_next = (SR << 1) with remainder part replaced by sub_res[7:0] and quotient LSB = 1.

                        // A better approach:
                        // 1) shift SR left by 1: SR << 1
                        // 2) replace remainder part bits [16:8] by sub_res
                        // 3) set quotient LSB to 1

                        // Implemented below.
                    end else begin
                        // subtraction failed: keep remainder unchanged and shift in quotient bit = 0
                        // Shift SR left by 1, quotient LSB=0
                        // Implemented below.
                        SR <= SR; // temporary placeholder, replaced below
                    end
                end

                DONE: begin
                    // Compute final signed quotient and remainder here
                    res_valid <= 1'b1;

                    // Extract remainder and quotient from SR:
                    // remainder is bits [16:8], quotient is bits [7:0]
                    // remainder has 9 bits, the MSB (bit 16) is sign bit for remainder (in unsigned arithmetic, usually 0)
                    // For result, we take remainder bits [16:9] as remainder[7:0]

                    // Compute signs of quotient and remainder
                    // quotient sign = sign & (dividend_neg ^ divisor_neg)
                    // remainder sign = sign & dividend_neg

                    // Convert back to signed values accordingly

                    // Assign in combinational block below (to avoid mixing signals inside clocked block)
                end
            endcase
        end
    end

    // Correct RUNNING state SR update (separate always block)
    always @(posedge clk) begin
        if (!rst && state == RUNNING) begin
            // Shift SR left by 1 bit
            // Temporary shifted SR:
            reg [16:0] SR_shifted;
            SR_shifted = SR << 1;

            if (~borrow) begin
                // When subtraction succeeds:
                // Replace remainder part (bits [16:8]) with sub_res, and quotient LSB = 1
                // SR_shifted bits [16:8] are replaced with sub_res[8:0]
                // quotient LSB (bit 0) set to 1
                SR <= {sub_res, SR_shifted[7:1], 1'b1};
            end else begin
                // When subtraction fails:
                // Keep remainder part unchanged (before shift), so use SR[16:8]
                // quotient LSB set to 0
                SR <= {remainder_part, SR_shifted[7:1], 1'b0};
            end
        end
    end

    // Combinational logic to compute final result at DONE state
    always @(*) begin
        if (state == DONE) begin
            reg [7:0] quotient_raw;
            reg [7:0] remainder_raw;
            reg quotient_sign;
            reg remainder_sign;
            reg [7:0] quotient_signed;
            reg [7:0] remainder_signed;

            // quotient raw is bits [7:0] of SR
            quotient_raw = SR[7:0];
            // remainder raw is bits [16:9] of SR (discarding bit 8, extra bit)
            remainder_raw = SR[16:9];

            quotient_sign = sign & (dividend_neg ^ divisor_neg);
            remainder_sign = sign & dividend_neg;

            // Convert quotient to signed if needed
            if (quotient_sign)
                quotient_signed = (~quotient_raw) + 1'b1;
            else
                quotient_signed = quotient_raw;

            // Convert remainder to signed if needed
            if (remainder_sign)
                remainder_signed = (~remainder_raw) + 1'b1;
            else
                remainder_signed = remainder_raw;

            result = {remainder_signed, quotient_signed};
        end else begin
            result = 16'd0;
        end
    end

endmodule