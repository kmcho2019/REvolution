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
        IDLE   = 2'b00,
        DIVIDE = 2'b01,
        DONE   = 2'b10
    } state_t;

    state_t state, next_state;

    // Counter for division iterations (0..8)
    reg [3:0] cnt;

    // Registers for remainder (9 bits) and quotient (8 bits)
    reg [8:0] remainder;
    reg [7:0] quotient;

    // Registers to hold absolute values and sign flags
    reg [7:0] dividend_abs;
    reg [8:0] divisor_abs;
    reg       dividend_neg;
    reg       divisor_neg;

    // Flags for sign correction after division
    reg quotient_neg;
    reg remainder_neg;

    // Combinational subtraction result: remainder - divisor_abs
    wire signed [9:0] sub_res;
    assign sub_res = $signed({1'b0, remainder}) - $signed(divisor_abs);

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (opn_valid && !res_valid)
                    next_state = DIVIDE;
            end
            DIVIDE: begin
                if (cnt == 4'd8)
                    next_state = DONE;
            end
            DONE: begin
                // Wait here until result consumed (opn_valid low)
                if (!opn_valid)
                    next_state = IDLE;
            end
        endcase
    end

    // Sequential block for FSM and data path
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            cnt <= 4'd0;
            remainder <= 9'd0;
            quotient <= 8'd0;
            dividend_abs <= 8'd0;
            divisor_abs <= 9'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
            result <= 16'd0;
            res_valid <= 1'b0;
        end else begin
            state <= next_state;

            case (next_state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    quotient <= 8'd0;
                    remainder <= 9'd0;
                    if (opn_valid && !res_valid) begin
                        // Calculate absolute value of dividend
                        if (sign && dividend[7]) begin
                            dividend_abs <= (~dividend) + 1'b1;
                            dividend_neg <= 1'b1;
                        end else begin
                            dividend_abs <= dividend;
                            dividend_neg <= 1'b0;
                        end
                        // Calculate absolute value of divisor
                        if (sign && divisor[7]) begin
                            divisor_abs <= {1'b0, (~divisor) + 1'b1};
                            divisor_neg <= 1'b1;
                        end else begin
                            divisor_abs <= {1'b0, divisor};
                            divisor_neg <= 1'b0;
                        end
                        // Sign flags for quotient and remainder
                        quotient_neg <= sign && (dividend[7] ^ divisor[7]);
                        remainder_neg <= sign && dividend[7];
                        // Initialize remainder: dividend_abs shifted left by 1 bit (9 bits)
                        remainder <= {dividend_abs, 1'b0};
                    end
                end

                DIVIDE: begin
                    cnt <= cnt + 1'b1;

                    // Shift remainder left by 1 before subtracting divisor_abs
                    // We need to consider remainder << 1 minus divisor_abs
                    // But remainder already shifted on previous iteration for quotient bit set to 0 case,
                    // so here we do subtraction on current remainder

                    if (sub_res >= 0) begin
                        // Subtraction successful: update remainder, set quotient bit = 1
                        remainder <= sub_res[8:0];
                        quotient <= {quotient[6:0], 1'b1};
                    end else begin
                        // Restore remainder shifted left by 1, quotient bit = 0
                        remainder <= remainder << 1;
                        quotient <= {quotient[6:0], 1'b0};
                    end
                end

                DONE: begin
                    // Apply sign correction to quotient and remainder before output
                    reg [7:0] q_corr;
                    reg [7:0] r_corr;
                    reg [7:0] rem_8bit;
                    rem_8bit = remainder[8:1]; // upper 8 bits of remainder shifted (drop LSB used during division)

                    if (sign) begin
                        // Quotient sign correction
                        if (quotient_neg)
                            q_corr = (~quotient) + 1'b1;
                        else
                            q_corr = quotient;

                        // Remainder sign correction
                        if (remainder_neg)
                            r_corr = (~rem_8bit) + 1'b1;
                        else
                            r_corr = rem_8bit;
                    end else begin
                        q_corr = quotient;
                        r_corr = rem_8bit;
                    end

                    result <= {r_corr, q_corr};
                    res_valid <= 1'b1;
                end

                default: begin
                    // Default safe reset for registers if needed
                end
            endcase
        end
    end

endmodule