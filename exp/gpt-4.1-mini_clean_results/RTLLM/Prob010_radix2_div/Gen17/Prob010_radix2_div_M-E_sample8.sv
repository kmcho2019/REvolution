module radix2_div (
    input               clk,
    input               rst,
    input               sign,           // 1: signed division, 0: unsigned
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg  [15:0]  result          // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    localparam IDLE   = 2'd0;
    localparam DIVIDE = 2'd1;
    localparam DONE   = 2'd2;

    reg [1:0] state, next_state;

    reg [3:0] cnt;

    // Registers for the division process
    reg signed [8:0] remainder;     // 9-bit signed remainder (extra bit for sign)
    reg [7:0]       quotient;

    reg [7:0]       dividend_abs;
    reg [8:0]       divisor_abs;    // zero-extended to 9 bits for signed ops

    reg             dividend_neg;
    reg             divisor_neg;
    reg             quotient_neg;
    reg             remainder_neg;

    // Signals for subtraction/addition in non-restoring division
    wire signed [9:0] sub_val;      // remainder - divisor_abs
    wire signed [9:0] add_val;      // remainder + divisor_abs

    // Next remainder computation depending on sign of remainder
    reg signed [8:0] next_remainder;
    reg [7:0]        next_quotient;

    // FSM Next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = (opn_valid) ? DIVIDE : IDLE;
            DIVIDE: next_state = (cnt == 4'd8) ? DONE : DIVIDE;
            DONE:   next_state = (!opn_valid) ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Compute absolute values and signs for input
    wire [7:0] dividend_abs_w = (sign && dividend[7]) ? (~dividend + 1'b1) : dividend;
    wire [7:0] divisor_abs_w  = (sign && divisor[7])  ? (~divisor  + 1'b1) : divisor;

    wire dividend_neg_w = (sign && dividend[7]);
    wire divisor_neg_w  = (sign && divisor[7]);

    // Non-restoring division combinational arithmetic
    assign sub_val = remainder - divisor_abs;
    assign add_val = remainder + divisor_abs;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            cnt <= 0;
            remainder <= 0;
            quotient <= 0;
            dividend_abs <= 0;
            divisor_abs <= 0;
            dividend_neg <= 0;
            divisor_neg <= 0;
            quotient_neg <= 0;
            remainder_neg <= 0;
            res_valid <= 0;
            result <= 0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 0;
                    quotient <= 0;
                    remainder <= 0;

                    if (opn_valid) begin
                        // Latch absolute values and signs
                        dividend_abs <= dividend_abs_w;
                        divisor_abs <= {1'b0, divisor_abs_w}; // extend to 9 bits

                        dividend_neg <= dividend_neg_w;
                        divisor_neg <= divisor_neg_w;

                        quotient_neg <= dividend_neg_w ^ divisor_neg_w;
                        remainder_neg <= dividend_neg_w;

                        // Initialize registers
                        // remainder starts with 0
                        remainder <= 9'sd0;
                        quotient <= 8'd0;
                        cnt <= 0;
                    end
                end

                DIVIDE: begin
                    // Non-restoring division step:
                    // Shift left {remainder, quotient} by 1 bit
                    // Then add or subtract divisor_abs depending on sign of remainder before shift

                    // Shift left remainder and quotient combined:
                    // [remainder(9 bits), quotient(8 bits)] form a 17-bit register conceptually
                    // At each iteration:
                    //   shift left by 1 bit:
                    //     remainder <= {remainder[7:0], quotient[7]}
                    //     quotient <= {quotient[6:0], 0}

                    remainder <= {remainder[7:0], quotient[7]};
                    quotient <= {quotient[6:0], 1'b0};

                    // Apply add or subtract after shift
                    // If previous remainder >= 0, next remainder = remainder - divisor_abs
                    // else next remainder = remainder + divisor_abs
                    // But since remainder is updated above, do this at next cycle

                    // Use a temporary variable for updated remainder
                end

                default: begin
                    // Wait for results; correct signs and produce output
                    if (state == DONE) begin
                        // Final sign correction:
                        reg [7:0] final_quotient;
                        reg [7:0] final_remainder;

                        // remainder is signed 9-bit; we take bits [8:1] for remainder value
                        // Because remainder shifted in quotient bits during last step
                        // So extract remainder from bits [8:1] of remainder register:
                        // actually the remainder should be adjusted according to the algorithm

                        // Because of non-restoring division, need to do one final correction:
                        // If remainder < 0 then remainder += divisor_abs, quotient -= 1
                        if (remainder < 0) begin
                            remainder <= remainder + divisor_abs;
                            quotient <= quotient - 1;
                        end

                        // Now extract remainder bits [8:1] as the true remainder (8 bits)
                        final_remainder = remainder[8:1];

                        // Correct signs
                        if (sign) begin
                            if (quotient_neg)
                                final_quotient = (~quotient) + 1'b1;
                            else
                                final_quotient = quotient;

                            if (remainder_neg)
                                final_remainder = (~final_remainder) + 1'b1;
                        end else begin
                            final_quotient = quotient;
                            final_remainder = remainder[8:1];
                        end

                        result <= {final_remainder, final_quotient};
                        res_valid <= 1'b1;
                    end
                end
            endcase

            if (state == DIVIDE) begin
                // After shifting registers, perform next remainder update

                // Use next_remainder logic here
                if (remainder[8] == 0) begin
                    // remainder >= 0
                    // next remainder = remainder - divisor_abs
                    if (sub_val[9] == 0) begin
                        // subtraction didn't go negative, accept subtraction
                        remainder <= sub_val[8:0];
                        quotient[0] <= 1'b1; // set LSB of quotient to 1
                    end else begin
                        // subtraction negative, restore previous remainder
                        // quotient bit stays 0 (already shifted in 0)
                        // remainder stays as is (after shift)
                    end
                end else begin
                    // remainder < 0
                    // next remainder = remainder + divisor_abs
                    if (add_val[9] == 0) begin
                        // addition result non-negative, accept addition
                        remainder <= add_val[8:0];
                        quotient[0] <= 1'b0; // quotient bit remains 0
                    end else begin
                        // addition negative, restore previous remainder
                        // quotient bit stays 0
                        // remainder stays as is (after shift)
                    end
                end

                cnt <= cnt + 1'b1;
            end

            if (state == IDLE) begin
                res_valid <= 1'b0; // clear valid when starting new op or idle
            end
        end
    end

endmodule