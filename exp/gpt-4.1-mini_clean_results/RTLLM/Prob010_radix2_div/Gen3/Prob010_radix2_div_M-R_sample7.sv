module radix2_div(
    input             clk,
    input             rst,
    input             sign,          // 1 for signed division, 0 for unsigned
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result         // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE   = 2'd0,
        DIVIDE = 2'd1,
        DONE   = 2'd2
    } state_t;

    reg [1:0] state, next_state;

    // Internal registers for operands and control
    reg [7:0] dividend_abs, divisor_abs;
    reg dividend_neg, divisor_neg;
    reg sign_quotient, sign_remainder;

    reg [8:0] remainder;  // 9-bit remainder register for subtraction and shift
    reg [7:0] quotient;   // 8-bit quotient register
    reg [3:0] cnt;        // cycle counter: counts up to 8

    // For subtraction result
    reg [9:0] sub_result;  // 10-bit to capture borrow flag + 9-bit subtraction
    wire sub_borrow;

    // Absolute value function
    function [7:0] abs_8;
        input [7:0] val;
        begin
            abs_8 = val[7] ? (~val + 1) : val;
        end
    endfunction

    // Compute subtraction and borrow
    // remainder - divisor_abs
    // remainder and divisor_abs are 9-bit for sign bit, so extend divisor_abs with leading 0 for correct unsigned subtraction
    always @(*) begin
        sub_result = {1'b0, remainder} - {1'b0, divisor_abs};
    end

    assign sub_borrow = sub_result[9]; // borrow if MSB is 1 (subtraction underflow)

    // FSM sequential block
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            res_valid <= 1'b0;
            result <= 16'd0;
            remainder <= 9'd0;
            quotient <= 8'd0;
            cnt <= 4'd0;
            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg <= 1'b0;
            sign_quotient <= 1'b0;
            sign_remainder <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    result <= 16'd0;
                    if (opn_valid && divisor != 8'd0) begin
                        // Capture and preprocess inputs
                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg <= divisor[7];
                            dividend_abs <= abs_8(dividend);
                            divisor_abs <= abs_8(divisor);
                            sign_quotient <= dividend[7] ^ divisor[7];
                            sign_remainder <= dividend[7];
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg <= 1'b0;
                            dividend_abs <= dividend;
                            divisor_abs <= divisor;
                            sign_quotient <= 1'b0;
                            sign_remainder <= 1'b0;
                        end
                        remainder <= {1'b0, abs_8(dividend)}; // 9-bit remainder with leading 0 bit
                        quotient <= 8'd0;
                        cnt <= 4'd0;
                    end
                end
                DIVIDE: begin
                    // Perform subtraction remainder - divisor_abs
                    if (!sub_borrow) begin
                        // If no borrow, update remainder and set quotient bit to 1
                        remainder <= sub_result[8:0] << 1;
                        quotient <= {quotient[6:0], 1'b1};
                    end else begin
                        // If borrow, keep remainder and set quotient bit 0
                        remainder <= remainder << 1;
                        quotient <= {quotient[6:0], 1'b0};
                    end
                    cnt <= cnt + 1'b1;
                end
                DONE: begin
                    // Wait for opn_valid low to clear res_valid and go back to IDLE
                    // Output final result prepared in combinational logic below
                    res_valid <= 1'b1;
                end
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (opn_valid && divisor != 8'd0)
                    next_state = DIVIDE;
                else if (opn_valid && divisor == 8'd0)
                    next_state = DONE;  // Division by zero, output zero immediately
            end
            DIVIDE: begin
                if (cnt == 4'd8)
                    next_state = DONE;
            end
            DONE: begin
                if (!opn_valid)
                    next_state = IDLE;
            end
        endcase
    end

    // Final result registers
    reg [7:0] quotient_signed;
    reg [7:0] remainder_signed;

    always @(*) begin
        if (state == DONE) begin
            // The remainder in remainder[8:1], quotient stored in quotient
            // remainder reg is shifted left during calculation, so the remainder bits are in remainder[8:1]
            // quotient is final quotient
            // Apply sign corrections if signed
            if (sign) begin
                // Quotient sign correction
                if (sign_quotient)
                    quotient_signed = (~quotient + 1);
                else
                    quotient_signed = quotient;

                // Remainder sign correction
                // remainder[8:1] is 8 bits remainder
                remainder_signed = sign_remainder ? (~remainder[8:1] + 1) : remainder[8:1];
            end else begin
                quotient_signed = quotient;
                remainder_signed = remainder[8:1];
            end
        end else begin
            quotient_signed = 8'd0;
            remainder_signed = 8'd0;
        end
    end

    // Update result on DONE state entry
    always @(posedge clk) begin
        if (rst)
            result <= 16'd0;
        else if (state == DONE)
            result <= {remainder_signed, quotient_signed};
        else if (opn_valid && divisor == 8'd0 && state == IDLE)
            // Division by zero immediate output zero
            result <= 16'd0;
    end

endmodule