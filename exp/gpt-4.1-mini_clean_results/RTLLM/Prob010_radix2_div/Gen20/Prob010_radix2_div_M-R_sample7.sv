module radix2_div (
    input               clk,
    input               rst,
    input               sign,
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg  [15:0]  result           // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    localparam IDLE  = 2'd0;
    localparam RUN   = 2'd1;
    localparam DONE  = 2'd2;

    reg [1:0] state, next_state;

    // Input signs and absolute values
    reg dividend_sign, divisor_sign;
    reg [7:0] abs_dividend, abs_divisor;

    // Shift register: 17 bits = {remainder[8:0], quotient[7:0]}
    reg [16:0] shift_reg;
    reg [16:0] shift_reg_next;

    // Iteration counter
    reg [3:0] count, count_next;

    // Divide-by-zero flag latched
    reg div_by_zero;

    // Trial subtraction signals (combinational)
    wire [8:0] remainder_in;
    wire [8:0] trial_sub;
    wire       trial_sub_nonneg;

    // Output registers before sign correction
    reg [7:0] quotient_raw;
    reg [7:0] remainder_raw;

    // Sign correction helpers
    function [7:0] abs8;
        input [7:0] val;
        begin
            abs8 = val[7] ? (~val + 8'd1) : val;
        end
    endfunction

    function [7:0] neg8;
        input [7:0] val;
        begin
            neg8 = ~val + 8'd1;
        end
    endfunction

    // Assign remainder portion from shift_reg
    assign remainder_in = shift_reg[16:8];

    // Trial subtraction: remainder - divisor
    assign trial_sub = {1'b0, remainder_in} - {1'b0, abs_divisor};
    assign trial_sub_nonneg = ~trial_sub[8]; // no borrow means nonnegative

    // FSM combinational next_state logic
    always @(*) begin
        case(state)
            IDLE:
                if (opn_valid)
                    next_state = RUN;
                else
                    next_state = IDLE;

            RUN:
                if (div_by_zero)
                    next_state = DONE;
                else if (count == 4'd8)
                    next_state = DONE;
                else
                    next_state = RUN;

            DONE:
                if (!opn_valid)
                    next_state = IDLE;
                else
                    next_state = DONE;

            default: next_state = IDLE;
        endcase
    end

    // Combinational logic for next values of count and shift_reg
    always @(*) begin
        // Default assignments to hold current values
        count_next = count;
        shift_reg_next = shift_reg;

        if (state == IDLE && opn_valid) begin
            // On start, latch absolute dividend and divisor with zero remainder
            // remainder part zero, quotient = abs_dividend
            shift_reg_next = {9'd0, abs_dividend};
            count_next = 4'd0;
        end else if (state == RUN && !div_by_zero) begin
            // Shift left one bit: remainder and quotient shifted left by 1
            // Insert 0 in quotient LSB by default
            shift_reg_next = {shift_reg[15:0], 1'b0};

            // Trial subtraction after shift:
            // Use trial_sub to decide if remainder updated and quotient bit set
            if (trial_sub_nonneg) begin
                // Replace remainder with trial_sub result, quotient LSB set to 1
                shift_reg_next[16:8] = trial_sub[8:0];
                shift_reg_next[0] = 1'b1;
            end

            count_next = count + 1'b1;
        end
        // else keep values
    end

    // Sequential logic for state, registers, and outputs
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state          <= IDLE;
            count          <= 4'd0;
            shift_reg      <= 17'd0;
            dividend_sign  <= 1'b0;
            divisor_sign   <= 1'b0;
            abs_dividend   <= 8'd0;
            abs_divisor    <= 8'd0;
            div_by_zero    <= 1'b0;
            res_valid      <= 1'b0;
            quotient_raw   <= 8'd0;
            remainder_raw  <= 8'd0;
            result         <= 16'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Latch signs and absolute values for signed operation
                        if (sign) begin
                            dividend_sign <= dividend[7];
                            divisor_sign  <= divisor[7];
                            abs_dividend  <= abs8(dividend);
                            abs_divisor   <= abs8(divisor);
                        end else begin
                            dividend_sign <= 1'b0;
                            divisor_sign  <= 1'b0;
                            abs_dividend  <= dividend;
                            abs_divisor   <= divisor;
                        end
                        // Check divide-by-zero
                        div_by_zero <= (divisor == 8'd0);
                        // Initialize shift_reg and count in combinational logic
                        shift_reg <= shift_reg_next;
                        count <= count_next;
                    end
                end

                RUN: begin
                    if (div_by_zero) begin
                        // No iteration if divide-by-zero
                        count <= count;
                        shift_reg <= shift_reg;
                    end else begin
                        // Update count and shift_reg from combinational next values
                        count <= count_next;
                        shift_reg <= shift_reg_next;
                    end
                end

                DONE: begin
                    if (!res_valid) begin
                        // Extract raw quotient and remainder from shift_reg
                        // quotient is lower 8 bits
                        // remainder is upper 8 bits of remainder portion (bits 16:9)
                        quotient_raw  <= shift_reg[7:0];
                        remainder_raw <= shift_reg[16:9];

                        // Apply sign correction and div-by-zero handling
                        if (div_by_zero) begin
                            // quotient all ones, remainder = dividend (signed or unsigned)
                            result[7:0]   <= 8'hFF; // quotient
                            if (sign && dividend_sign)
                                result[15:8] <= neg8(abs_dividend); // remainder
                            else
                                result[15:8] <= abs_dividend;
                        end else begin
                            // Normal sign correction
                            // Quotient sign = dividend_sign ^ divisor_sign
                            if (sign) begin
                                result[7:0] <= (dividend_sign ^ divisor_sign) ? neg8(quotient_raw) : quotient_raw;
                                // remainder sign = dividend sign
                                result[15:8] <= dividend_sign ? neg8(remainder_raw) : remainder_raw;
                            end else begin
                                result <= {remainder_raw, quotient_raw};
                            end
                        end

                        res_valid <= 1'b1;
                    end else if (!opn_valid) begin
                        // Clear valid when no new operation requested
                        res_valid <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule