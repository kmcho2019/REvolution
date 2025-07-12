module radix2_div (
    input               clk,
    input               rst,
    input               sign,
    input       [7:0]   dividend,
    input       [7:0]   divisor,
    input               opn_valid,
    output reg          res_valid,
    output reg  [15:0]  result       // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    localparam IDLE  = 2'b00;
    localparam RUN   = 2'b01;
    localparam DONE  = 2'b10;

    reg [1:0] state, next_state;

    // Internal registers
    reg dividend_sign, divisor_sign;
    reg [7:0] abs_dividend, abs_divisor;

    // 17-bit shift register: [16:8] remainder(9 bits), [7:0] quotient(8 bits)
    reg [16:0] shift_reg;

    // Iteration counter: counts from 1 to 8
    reg [3:0] count;

    // Raw outputs before sign correction
    reg [7:0] quotient_raw;
    reg [7:0] remainder_raw;

    // Helpers: absolute value and negation for 8-bit values
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

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (opn_valid && !res_valid)
                    next_state = RUN;
                else
                    next_state = IDLE;
            end
            RUN: begin
                if (count == 4'd8)
                    next_state = DONE;
                else
                    next_state = RUN;
            end
            DONE: begin
                // Return to IDLE when result consumed (res_valid cleared)
                if (!opn_valid && res_valid == 0)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential block
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state          <= IDLE;
            res_valid      <= 1'b0;
            result         <= 16'd0;
            shift_reg      <= 17'd0;
            count          <= 4'd0;
            dividend_sign  <= 1'b0;
            divisor_sign   <= 1'b0;
            abs_dividend   <= 8'd0;
            abs_divisor    <= 8'd0;
            quotient_raw   <= 8'd0;
            remainder_raw  <= 8'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    count <= 4'd0;
                    quotient_raw <= 8'd0;
                    remainder_raw <= 8'd0;

                    if (opn_valid && !res_valid) begin
                        // Capture signs and absolute values
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

                        // Initialize shift_reg: remainder 9 bits = 0, quotient 8 bits = abs_dividend
                        // This sets remainder=0 and quotient=dividend absolute value
                        shift_reg <= {9'd0, abs_dividend};

                        // Initialize count to 1 to start division iterations at next clock
                        count <= 4'd1;
                    end
                end

                RUN: begin
                    // Classic restoring division iteration:

                    // Step 1: Shift shift_reg left by 1 bit
                    // This shifts the combined remainder and quotient register left by 1
                    // and appends a zero at the LSB of quotient for next bit calculation.
                    // To avoid partial bit assignments, do all in one nonblocking assign at end.

                    reg [16:0] shift_reg_next;
                    reg [8:0] remainder_sub;
                    reg       sub_nonneg;

                    // Shift left by 1:
                    shift_reg_next = {shift_reg[15:0], 1'b0};

                    // Trial subtraction: remainder - divisor
                    // remainder is bits [16:8] (9 bits)
                    // divisor is 8 bits extended with 0 MSB
                    remainder_sub = {1'b0, shift_reg_next[16:8]} - {1'b0, abs_divisor};
                    sub_nonneg = ~remainder_sub[8]; // MSB 0 means no borrow => remainder_sub >= 0

                    if (sub_nonneg) begin
                        // Subtraction non-negative: update remainder bits with subtraction result,
                        // set quotient LSB bit to 1
                        // shift_reg_next[16:8] = remainder_sub[8:0]
                        // shift_reg_next[0] = 1
                        shift_reg_next[16:8] = remainder_sub[8:0];
                        shift_reg_next[0]    = 1'b1;
                    end
                    // else subtraction negative: keep shift_reg_next unchanged (restoring)

                    // Update shift_reg and count
                    shift_reg <= shift_reg_next;
                    count <= count + 1'b1;
                end

                DONE: begin
                    // Latch raw quotient and remainder from shift_reg
                    // remainder is bits [16:9] (8 bits), lower bit of remainder was extra for carry
                    remainder_raw <= shift_reg[16:9];
                    quotient_raw  <= shift_reg[7:0];

                    res_valid <= 1'b1;

                    // Sign correction and division by zero handling
                    if (abs_divisor == 8'd0) begin
                        // Divisor zero:
                        // quotient = 0xFF (all ones)
                        // remainder = dividend (signed or unsigned)
                        result[7:0]   <= 8'hFF;
                        if (sign && dividend_sign)
                            result[15:8] <= neg8(abs_dividend);
                        else
                            result[15:8] <= abs_dividend;
                    end else begin
                        // Normal division with sign correction
                        reg [7:0] quotient_signed;
                        reg [7:0] remainder_signed;

                        if (sign) begin
                            // quotient sign = dividend_sign ^ divisor_sign
                            if (dividend_sign ^ divisor_sign)
                                quotient_signed = neg8(quotient_raw);
                            else
                                quotient_signed = quotient_raw;

                            // remainder sign same as dividend_sign
                            if (dividend_sign)
                                remainder_signed = neg8(remainder_raw);
                            else
                                remainder_signed = remainder_raw;
                        end else begin
                            quotient_signed = quotient_raw;
                            remainder_signed = remainder_raw;
                        end

                        result[7:0]   <= quotient_signed;
                        result[15:8]  <= remainder_signed;
                    end

                    // Automatically clear res_valid on next opn_valid or reset handled by next states
                    if (!opn_valid) begin
                        // If no new operation request, clear res_valid to allow new op
                        res_valid <= 1'b0;
                    end
                end

                default: begin
                    // Should not happen, go to IDLE safe state
                    state <= IDLE;
                    res_valid <= 1'b0;
                end
            endcase
        end
    end

endmodule