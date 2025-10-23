module radix2_div (
    input          clk,
    input          rst,
    input          sign,            // 1: signed division, 0: unsigned
    input    [7:0] dividend,
    input    [7:0] divisor,
    input          opn_valid,
    output reg     res_valid,
    output reg [15:0] result        // {remainder[7:0], quotient[7:0]}
);

    reg [16:0] SR;          // {remainder[8:0], quotient[7:0]} with extra bit for subtraction
    reg [8:0]  neg_divisor; // two's complement negative divisor (9 bits)
    reg [3:0]  cnt;         // iteration counter (1 to 8)
    reg        busy;

    reg        dividend_sign;
    reg        divisor_sign;
    reg [7:0]  dividend_abs;
    reg [7:0]  divisor_abs;

    // Absolute value function for signed numbers
    function [7:0] abs8;
        input [7:0] val;
        input       is_signed;
        begin
            abs8 = (is_signed && val[7]) ? (~val + 8'd1) : val;
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
                if (opn_valid && !res_valid && (divisor != 8'd0)) begin
                    // Capture signs and absolute values
                    dividend_sign <= sign && dividend[7];
                    divisor_sign  <= sign && divisor[7];
                    dividend_abs  <= abs8(dividend, sign);
                    divisor_abs   <= abs8(divisor, sign);

                    neg_divisor <= {1'b1, ~abs8(divisor, sign)} + 9'd1; // -divisor in 9 bits
                    SR <= {9'd0, abs8(dividend, sign)} << 1; // remainder=0, quotient=dividend_abs shifted left by 1
                    cnt <= 4'd1;
                    busy <= 1'b1;
                    res_valid <= 1'b0;
                end
            end else begin
                // Subtract divisor from remainder part
                {SR[16], SR[15:8]} = SR[16:8] + neg_divisor; // 9-bit add with borrow handling (SR[16] is carry-out)

                // Update quotient bit and shift left
                if (SR[16]) begin
                    // Subtraction successful (no borrow)
                    SR = {SR[15:0], 1'b1};
                end else begin
                    // Borrow occurred; restore remainder and shift quotient bit as 0
                    SR = {SR[15:0], 1'b0};
                end

                if (cnt == 4'd8) begin
                    busy <= 1'b0;
                    res_valid <= 1'b1;

                    // Extract quotient and remainder before sign correction
                    // Remainder is SR[16:9], quotient is SR[7:0]
                    // Correct signs if signed operation

                    if (sign && (dividend_sign ^ divisor_sign))
                        result[7:0] <= (~SR[7:0] + 8'd1); // quotient negated
                    else
                        result[7:0] <= SR[7:0];

                    if (sign && dividend_sign)
                        result[15:8] <= (~SR[16:9] + 8'd1); // remainder negated
                    else
                        result[15:8] <= SR[16:9];
                end else begin
                    cnt <= cnt + 4'd1;
                end
            end

            // Clear result valid if new op starts and not busy
            if (res_valid && opn_valid && !busy)
                res_valid <= 1'b0;
        end
    end
endmodule