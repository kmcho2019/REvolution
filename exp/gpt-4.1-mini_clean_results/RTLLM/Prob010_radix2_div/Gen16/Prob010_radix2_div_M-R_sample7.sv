module radix2_div (
    input           clk,
    input           rst,
    input           sign,           // 1: signed division, 0: unsigned
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output reg      res_valid,
    output reg [15:0] result         // {remainder[7:0], quotient[7:0]}
);

    // FSM states
    localparam IDLE = 2'd0;
    localparam RUN  = 2'd1;
    localparam DONE = 2'd2;

    reg [1:0] state, next_state;

    // Internal registers
    reg [7:0] dividend_abs, divisor_abs;
    reg       dividend_sign, divisor_sign;

    // 9-bit remainder register (one extra bit for subtraction borrow)
    reg [8:0] remainder;

    // 8-bit quotient register
    reg [7:0] quotient;

    // 9-bit negated divisor (two's complement)
    reg [8:0] neg_divisor;

    reg [3:0] cnt;  // iteration counter: counts 0..8

    // Subtraction result and borrow
    reg [8:0] sub_res;
    wire      borrow;  // borrow signal from subtraction: borrow = ~carry out of add

    // Absolute value function for 8-bit inputs
    function [7:0] abs8;
        input [7:0] val;
        input       s;  // sign enable
        begin
            abs8 = (s && val[7]) ? (~val + 8'd1) : val;
        end
    endfunction

    // Sign correction function for 8-bit two's complement
    function [7:0] sign_correct_quotient;
        input [7:0] val;
        input       negate;
        begin
            sign_correct_quotient = negate ? (~val + 8'd1) : val;
        end
    endfunction

    function [7:0] sign_correct_remainder;
        input [7:0] val;
        input       negate;
        begin
            sign_correct_remainder = negate ? (~val + 8'd1) : val;
        end
    endfunction

    // Compute borrow from subtraction: borrow = !carry_out of addition
    assign borrow = ~sub_res[8]; 

    // Next-state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (opn_valid && !res_valid && divisor != 8'd0)
                    next_state = RUN;
                else
                    next_state = IDLE;
            end
            RUN: begin
                if (cnt == 4'd8)
                    next_state = DONE;
                else
                    next_state = RUN;
            end
            DONE: begin
                if (opn_valid)
                    next_state = RUN;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Main sequential block
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= IDLE;
            res_valid   <= 1'b0;
            result      <= 16'd0;
            quotient    <= 8'd0;
            remainder   <= 9'd0;
            dividend_abs <= 8'd0;
            divisor_abs  <= 8'd0;
            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
            neg_divisor <= 9'd0;
            cnt         <= 4'd0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    res_valid <= 1'b0;
                    cnt <= 4'd0;
                    quotient <= 8'd0;
                    remainder <= 9'd0;
                    if (opn_valid && divisor != 8'd0) begin
                        // Capture signs and absolute values
                        dividend_sign <= sign && dividend[7];
                        divisor_sign  <= sign && divisor[7];

                        dividend_abs <= abs8(dividend, sign);
                        divisor_abs  <= abs8(divisor, sign);

                        // neg_divisor = two's complement 9-bit of divisor_abs (sign extended)
                        // For subtraction: remainder + neg_divisor = remainder - divisor_abs
                        neg_divisor <= {1'b0, ~divisor_abs} + 9'd1;

                        // Initialize remainder with dividend_abs shifted left by 1 (to get 9-bit remainder)
                        remainder <= {dividend_abs, 1'b0};
                        quotient <= 8'd0;

                        cnt <= 4'd0;
                    end
                end

                RUN: begin
                    // Perform one iteration per clock: shift remainder left 1, subtract divisor, update quotient bit

                    // First shift remainder left by 1 bit, bringing in next quotient bit (MSB of remainder before shift)
                    // We perform subtraction of divisor from remainder:
                    // sub_res = remainder + neg_divisor;
                    sub_res <= remainder + neg_divisor;

                    // Wait one cycle for sub_res computation (combinational actually)
                    // Update remainder and quotient based on borrow
                    if (borrow) begin
                        // subtraction succeeded, update remainder with sub_res[7:0]
                        remainder <= {sub_res[7:0], 1'b0}; // shift left 1, insert 0 bit at LSB to prepare for next
                        quotient <= {quotient[6:0], 1'b1};
                    end else begin
                        // subtraction failed, keep remainder, shift left 1
                        remainder <= {remainder[7:0], 1'b0};
                        quotient <= {quotient[6:0], 1'b0};
                    end
                    cnt <= cnt + 4'd1;
                end

                DONE: begin
                    // Result is ready; apply sign correction

                    reg [7:0] final_quotient;
                    reg [7:0] final_remainder;

                    // remainder is 9 bits, upper bit is ignored, take lower 8 bits
                    final_remainder = remainder[8] ? 8'd0 : remainder[7:0]; 
                    // (Should never be negative, but just safeguard)

                    // Apply sign correction for quotient
                    final_quotient = sign_correct_quotient(quotient, dividend_sign ^ divisor_sign);
                    // Apply sign correction for remainder: remainder sign same as dividend sign
                    final_remainder = sign_correct_remainder(final_remainder, dividend_sign);

                    result <= {final_remainder, final_quotient};
                    res_valid <= 1'b1;

                    // cnt, remainder, quotient hold until new operation starts
                end
            endcase

            // Clear res_valid if new operation starts
            if ((state == IDLE) && opn_valid)
                res_valid <= 1'b0;
        end
    end
endmodule