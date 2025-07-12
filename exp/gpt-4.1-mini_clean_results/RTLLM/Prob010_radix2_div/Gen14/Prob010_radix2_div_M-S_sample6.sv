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

    reg [16:0] SR;          // {remainder[8:0], quotient[7:0]}, 9+8=17 bits
    reg [8:0]  neg_divisor; // -divisor absolute value extended
    reg [3:0]  cnt;         // 1 to 8 count for division steps
    reg        busy;

    reg        dividend_sign;
    reg        divisor_sign;
    reg [7:0]  dividend_abs;
    reg [7:0]  divisor_abs;

    // Function to get absolute value for signed input
    function [7:0] abs8;
        input [7:0] val;
        input       s; // sign enable
        begin
            abs8 = (s && val[7]) ? (~val + 8'd1) : val;
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR          <= 17'd0;
            neg_divisor <= 9'd0;
            cnt         <= 4'd0;
            busy        <= 1'b0;
            res_valid   <= 1'b0;
            result      <= 16'd0;
            dividend_sign <= 1'b0;
            divisor_sign  <= 1'b0;
            dividend_abs  <= 8'd0;
            divisor_abs   <= 8'd0;
        end else begin
            if (!busy) begin
                // Start new division if valid and divisor != 0 and result is not valid yet
                if (opn_valid && !res_valid && (divisor != 8'd0)) begin
                    dividend_sign <= sign && dividend[7];
                    divisor_sign  <= sign && divisor[7];
                    dividend_abs  <= abs8(dividend, sign);
                    divisor_abs   <= abs8(divisor, sign);

                    neg_divisor <= {1'b1, ~divisor_abs} + 9'd1; // Two's complement negative divisor
                    SR <= {dividend_abs, 8'd0} << 1; // Shift left by 1 for iteration
                    cnt <= 4'd1;
                    busy <= 1'b1;
                    res_valid <= 1'b0;
                end
            end else begin
                // Iterative division step
                // Subtract neg_divisor from remainder part of SR
                // remainder part is SR[16:8] (9 bits)
                {SR[16], SR[15:8]} = SR[16:8] + neg_divisor; // 9-bit addition, SR[16] is carry-out (borrow indicator inverted)

                if (SR[16] == 1'b1) begin
                    // Successful subtraction (no borrow)
                    SR = {SR[15:0], 1'b1}; // Shift left by 1 and insert quotient bit=1
                end else begin
                    // Borrow happened, restore remainder and insert quotient bit=0
                    SR = {SR[15:0], 1'b0};
                end

                if (cnt == 4'd8) begin
                    // Division done
                    busy <= 1'b0;
                    res_valid <= 1'b1;

                    // Extract raw quotient and remainder
                    // Quotient: SR[7:0]
                    // Remainder: SR[16:9]

                    // Apply sign correction
                    // Quotient sign if signed and dividend_sign xor divisor_sign
                    // Remainder sign if signed and dividend_sign

                    // Quotient correction
                    if (sign && (dividend_sign ^ divisor_sign))
                        result[7:0] <= (~SR[7:0] + 8'd1);
                    else
                        result[7:0] <= SR[7:0];

                    // Remainder correction
                    if (sign && dividend_sign)
                        result[15:8] <= (~SR[16:9] + 8'd1);
                    else
                        result[15:8] <= SR[16:9];
                end else begin
                    cnt <= cnt + 4'd1;
                end
            end

            // Clear res_valid if a new operation starts and we are not busy
            if (res_valid && opn_valid && !busy)
                res_valid <= 1'b0;
        end
    end
endmodule