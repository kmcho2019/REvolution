module radix2_div (
    input          clk,
    input          rst,
    input          sign,           // 1: signed division, 0: unsigned
    input    [7:0] dividend,
    input    [7:0] divisor,
    input          opn_valid,
    output reg     res_valid,
    output reg [15:0] result        // {remainder[7:0], quotient[7:0]}
);

    // Registers for operation
    reg [16:0] SR;           // Shift register: {remainder[8:0], quotient[7:0]} (9+8=17 bits)
    reg [8:0] NEG_DIVISOR;   // Negative divisor magnitude extended to 9 bits
    reg [3:0] cnt;           // Count from 1 to 8 cycles
    reg start_cnt;           // Start division flag

    // Latched inputs and signs
    reg dividend_sign;
    reg divisor_sign;
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;

    // Intermediate registers for result processing (moved outside always block)
    reg [7:0] raw_quotient;
    reg [7:0] raw_remainder;
    reg quotient_neg;
    reg remainder_neg;
    reg [7:0] corr_quotient;
    reg [7:0] corr_remainder;

    // Combinational wires
    wire [8:0] sub_result;
    wire borrow;

    // Subtract NEG_DIVISOR from upper 9 bits of SR (remainder part)
    assign {borrow, sub_result} = {1'b0, SR[16:8]} + NEG_DIVISOR;

    // Absolute value function (inline)
    function [7:0] abs8;
        input [7:0] val;
        input       s;
        begin
            if (s && val[7]) abs8 = (~val + 8'd1);
            else abs8 = val;
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR           <= 17'd0;
            NEG_DIVISOR  <= 9'd0;
            cnt          <= 4'd0;
            start_cnt    <= 1'b0;
            res_valid    <= 1'b0;
            result       <= 16'd0;
            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
            dividend_abs  <= 8'd0;
            divisor_abs   <= 8'd0;

            // Clear intermediate regs
            raw_quotient   <= 8'd0;
            raw_remainder  <= 8'd0;
            quotient_neg   <= 1'b0;
            remainder_neg  <= 1'b0;
            corr_quotient  <= 8'd0;
            corr_remainder <= 8'd0;
        end else begin
            if (!start_cnt) begin
                // Not currently dividing
                if (opn_valid && !res_valid && (divisor != 8'd0)) begin
                    // Latch signs and absolute values
                    dividend_sign <= sign && dividend[7];
                    divisor_sign  <= sign && divisor[7];
                    dividend_abs  <= abs8(dividend, sign);
                    divisor_abs   <= abs8(divisor, sign);

                    // NEG_DIVISOR = -divisor_abs extended to 9 bits
                    NEG_DIVISOR <= {1'b1, ~divisor_abs} + 9'd1; // two's complement negation
                    
                    // Initialize SR: remainder = dividend_abs shifted left 1, quotient=0
                    SR <= {dividend_abs, 8'd0} << 1;

                    cnt <= 4'd1;
                    start_cnt <= 1'b1;

                    res_valid <= 1'b0; // clear output valid on new operation
                end
            end else begin
                // Division iterative step
                if (!borrow) begin
                    // subtraction success: update remainder with sub_result and set quotient bit to 1
                    SR <= {sub_result, SR[7:1], 1'b1};
                end else begin
                    // subtraction fail: restore remainder, quotient bit = 0
                    SR <= {SR[16:8], SR[7:1], 1'b0};
                end

                if (cnt == 4'd8) begin
                    // Division complete
                    start_cnt <= 1'b0;

                    // Extract raw quotient and remainder
                    raw_quotient  <= SR[7:0];
                    raw_remainder <= SR[16:9];

                    quotient_neg  <= sign && (dividend_sign ^ divisor_sign);
                    remainder_neg <= sign && dividend_sign;

                    // Apply sign correction
                    corr_quotient  <= quotient_neg ? (~SR[7:0] + 8'd1) : SR[7:0];
                    corr_remainder <= remainder_neg ? (~SR[16:9] + 8'd1) : SR[16:9];

                    result <= {corr_remainder, corr_quotient};
                    res_valid <= 1'b1;
                end else begin
                    cnt <= cnt + 4'd1;
                end
            end

            // Clear res_valid on new operation request only if division not in progress
            if (res_valid && opn_valid && !start_cnt)
                res_valid <= 1'b0;
        end
    end
endmodule