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
    localparam IDLE = 2'd0;
    localparam RUN  = 2'd1;
    localparam DONE = 2'd2;

    reg [1:0] state, next_state;

    reg [3:0] cnt;

    // Registers for division process
    reg [8:0] remainder;    // 9-bit remainder register
    reg [7:0] quotient;     // 8-bit quotient register
    reg [7:0] dividend_reg; // shift dividend bits into remainder

    // Divisor absolute value (9 bits zero extended)
    reg [8:0] divisor_abs;

    // Flags for sign handling
    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;

    // Temporary subtraction result
    reg signed [9:0] sub_res;

    // Combinational next state and datapath logic
    always @(*) begin
        // Defaults
        next_state = state;

        case(state)
            IDLE: begin
                if (opn_valid)
                    next_state = RUN;
            end
            RUN: begin
                if (cnt == 4'd8)
                    next_state = DONE;
                else
                    next_state = RUN;
            end
            DONE: begin
                if (~opn_valid) // Wait for opn_valid to go low to start next operation
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential process: FSM and datapath
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            cnt <= 0;
            remainder <= 0;
            quotient <= 0;
            dividend_reg <= 0;
            divisor_abs <= 0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
            res_valid <= 1'b0;
            result <= 0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 0;
                    quotient <= 8'b0;
                    remainder <= 9'b0;

                    if (opn_valid) begin
                        // Determine sign and absolute values
                        if (sign && dividend[7]) begin
                            dividend_reg <= (~dividend) + 1'b1;
                            dividend_neg <= 1'b1;
                        end else begin
                            dividend_reg <= dividend;
                            dividend_neg <= 1'b0;
                        end

                        if (sign && divisor[7]) begin
                            divisor_abs <= (~divisor) + 1'b1;
                            divisor_neg <= 1'b1;
                        end else begin
                            divisor_abs <= {1'b0, divisor};
                            divisor_neg <= 1'b0;
                        end

                        quotient_neg <= sign && (dividend[7] ^ divisor[7]);
                        remainder_neg <= sign && dividend[7];

                        remainder <= 9'b0;
                        quotient <= 8'b0;
                        cnt <= 0;
                    end
                end

                RUN: begin
                    // Shift left remainder and bring in next dividend bit
                    remainder <= {remainder[7:0], dividend_reg[7]};
                    dividend_reg <= {dividend_reg[6:0], 1'b0};

                    // Compute remainder - divisor_abs
                    sub_res <= $signed({1'b0, remainder[8:0]}) - $signed(divisor_abs);

                    if (sub_res >= 0) begin
                        // Successful subtraction: remainder updated, quotient bit = 1
                        remainder <= sub_res[8:0];
                        quotient <= {quotient[6:0], 1'b1};
                    end else begin
                        // Restore remainder: shift left only, quotient bit = 0
                        // remainder already shifted above, so keep it
                        quotient <= {quotient[6:0], 1'b0};
                    end

                    cnt <= cnt + 1'b1;
                end

                DONE: begin
                    // Sign correction for quotient
                    reg [7:0] quotient_corr;
                    reg [7:0] remainder_corr;
                    reg [7:0] rem8;

                    // remainder is 9 bits but upper bit always 0 or sign extended, take bits [7:0]
                    rem8 = remainder[7:0];

                    if (sign) begin
                        quotient_corr = quotient_neg ? (~quotient + 1'b1) : quotient;
                        remainder_corr = remainder_neg ? (~rem8 + 1'b1) : rem8;
                    end else begin
                        quotient_corr = quotient;
                        remainder_corr = rem8;
                    end

                    result <= {remainder_corr, quotient_corr};
                    res_valid <= 1'b1;
                end

                default: begin
                    // Safe defaults
                    res_valid <= 1'b0;
                end
            endcase
        end
    end

endmodule