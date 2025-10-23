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

    // State encoding
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        RUNNING = 2'b01,
        DONE    = 2'b10
    } state_t;

    state_t state, next_state;

    // Registers for inputs and intermediate data
    reg [7:0] dividend_reg, divisor_reg;
    reg dividend_neg, divisor_neg;
    reg quotient_neg, remainder_neg;

    reg [8:0] remainder;       // 9-bit remainder (8 bits + carry)
    reg [7:0] quotient;
    reg [8:0] divisor_abs_9;   // 9-bit divisor absolute value
    reg [8:0] neg_divisor;     // two's complement of divisor_abs_9

    reg [3:0] count;           // counts 0..8 steps

    wire divisor_zero = (divisor_reg == 8'd0);

    // Absolute values of inputs
    wire [7:0] dividend_abs = (sign && dividend_reg[7]) ? (~dividend_reg + 1) : dividend_reg;
    wire [7:0] divisor_abs  = (sign && divisor_reg[7])  ? (~divisor_reg  + 1) : divisor_reg;

    // Prepare subtraction: remainder - divisor_abs
    wire [9:0] rem_sub = {1'b0, remainder} + {1'b0, ~divisor_abs_9} + 10'd1; // 10-bit subtraction remainder - divisor_abs
    wire sub_no_borrow = ~rem_sub[9]; // borrow bit cleared means remainder >= divisor_abs

    // Sequential state and data updates
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            dividend_reg <= 8'd0;
            divisor_reg  <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            quotient_neg <= 1'b0;
            remainder_neg<= 1'b0;
            remainder    <= 9'd0;
            quotient     <= 8'd0;
            divisor_abs_9<= 9'd0;
            neg_divisor  <= 9'd0;
            count        <= 4'd0;
            res_valid    <= 1'b0;
            result       <= 16'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        dividend_reg <= dividend;
                        divisor_reg  <= divisor;
                        dividend_neg <= (sign && dividend[7]);
                        divisor_neg  <= (sign && divisor[7]);
                        quotient_neg <= (sign && (dividend[7] ^ divisor[7]));
                        remainder_neg<= (sign && dividend[7]);

                        if (divisor_zero) begin
                            // Division by zero: produce zero result immediately
                            result <= 16'd0;
                            res_valid <= 1'b1;
                        end else begin
                            remainder <= {dividend_abs, 1'b0};  // dividend_abs shifted left by 1
                            quotient  <= 8'd0;
                            divisor_abs_9 <= {1'b0, divisor_abs}; // extend divisor_abs to 9 bits
                            neg_divisor <= (~{1'b0, divisor_abs}) + 9'd1;
                            count <= 4'd0;
                        end
                    end
                end

                RUNNING: begin
                    count <= count + 1'b1;

                    // Try remainder - divisor_abs
                    if (sub_no_borrow) begin
                        // remainder >= divisor: update remainder and set quotient bit
                        remainder <= rem_sub[8:0];
                        quotient  <= {quotient[6:0], 1'b1};
                    end else begin
                        // remainder < divisor: shift quotient with zero
                        remainder <= {remainder[7:0], 1'b0};
                        quotient  <= {quotient[6:0], 1'b0};
                    end
                end

                DONE: begin
                    // Apply sign corrections only once on entering DONE
                    if (res_valid == 1'b0) begin
                        reg [7:0] quotient_signed;
                        reg [7:0] remainder_signed;

                        quotient_signed = quotient_neg ? (~quotient + 1) : quotient;
                        remainder_signed = remainder_neg ? (~remainder[8:1] + 1) : remainder[8:1];

                        result <= {remainder_signed, quotient_signed};
                        res_valid <= 1'b1;
                    end

                    // Clear result if new operation requested
                    if (opn_valid) begin
                        res_valid <= 1'b0;
                    end
                end

            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (opn_valid) begin
                    if (divisor_zero) begin
                        next_state = DONE; // immediate done with zero result
                    end else begin
                        next_state = RUNNING;
                    end
                end else begin
                    next_state = IDLE;
                end
            end

            RUNNING: begin
                if (count == 4'd8) begin
                    next_state = DONE;
                end else begin
                    next_state = RUNNING;
                end
            end

            DONE: begin
                if (opn_valid) begin
                    next_state = IDLE;
                end else begin
                    next_state = DONE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule