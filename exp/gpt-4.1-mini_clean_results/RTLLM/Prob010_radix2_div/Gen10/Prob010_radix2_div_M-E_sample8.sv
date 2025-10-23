module radix2_div (
    input          clk,
    input          rst,
    input          sign,
    input  [7:0]   dividend,
    input  [7:0]   divisor,
    input          opn_valid,
    output reg     res_valid,
    output reg [15:0] result
);
    // Internal registers
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;
    reg       quotient_neg;
    reg       remainder_neg;
    reg [7:0] quotient;
    reg [8:0] remainder; // 9 bits to hold possible borrow
    reg [3:0] bit_cnt;
    reg       busy;

    // Compute absolute value function
    function [7:0] abs_val;
        input [7:0] val;
        begin
            abs_val = (sign && val[7]) ? (~val + 8'd1) : val;
        end
    endfunction

    // Two's complement negation
    function [7:0] neg_val;
        input [7:0] val;
        begin
            neg_val = ~val + 8'd1;
        end
    endfunction

    // Subtraction comparator: remainder - divisor_abs
    wire [8:0] sub_result = remainder - {1'b0, divisor_abs};
    wire       can_subtract = ~sub_result[8]; // MSB borrow bit 0 means remainder >= divisor_abs

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;
            quotient_neg <= 1'b0;
            remainder_neg <= 1'b0;
            quotient <= 8'd0;
            remainder <= 9'd0;
            bit_cnt <= 4'd0;
            busy <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'd0;
        end else begin
            if (!busy) begin
                res_valid <= 1'b0;
                if (opn_valid && !res_valid) begin
                    // Latch inputs
                    dividend_abs <= abs_val(dividend);
                    divisor_abs <= abs_val(divisor);
                    quotient_neg <= sign && (dividend[7] ^ divisor[7]);
                    remainder_neg <= sign && dividend[7];
                    quotient <= 8'd0;
                    remainder <= 9'd0;
                    bit_cnt <= 4'd8;
                    busy <= 1'b1;
                end
            end else begin
                // If divisor_abs == 0, division undefined; output zeros immediately
                if (divisor_abs == 8'd0) begin
                    quotient <= 8'd0;
                    remainder <= 9'd0;
                    bit_cnt <= 0;
                    busy <= 1'b0;
                    res_valid <= 1'b1;
                    result <= 16'd0;
                end else if (bit_cnt > 0) begin
                    // Shift remainder and quotient left by 1 bit, bring in next dividend_abs bit
                    // Get next dividend bit from MSB downwards
                    remainder <= {remainder[7:0], dividend_abs[bit_cnt-1]};
                    // Tentatively subtract divisor_abs if remainder large enough
                    if (~((remainder << 1)[8]) && ((remainder << 1) >= {1'b0, divisor_abs})) begin
                        // Attempt to subtract divisor_abs after shift and insert 1 in quotient LSB
                        // Actually perform the subtraction and set quotient LSB = 1
                        // To keep logic synchronous, compute sub_result after shift
                        // But since remainder was shifted, directly subtract divisor_abs
                        // We'll implement subtraction after the shift (remainder already updated)
                        // So calculate sub_result = remainder - divisor_abs
                        // We'll do this by pre-calculating sub_result based on updated remainder
                        // Use sub_result from above
                        if (can_subtract) begin
                            remainder <= sub_result;
                            quotient <= {quotient[6:0], 1'b1};
                        end else begin
                            quotient <= {quotient[6:0], 1'b0};
                        end
                    end else begin
                        // remainder too small, quotient bit = 0
                        quotient <= {quotient[6:0], 1'b0};
                    end
                    bit_cnt <= bit_cnt - 1;
                end else begin
                    // Division done, apply sign corrections
                    reg [7:0] q;
                    reg [7:0] r;
                    q = quotient;
                    r = remainder[7:0]; // remainder is 9 bits, upper bit should be zero after final subtraction

                    if (sign) begin
                        if (quotient_neg) q = neg_val(q);
                        if (remainder_neg) r = neg_val(r);
                    end

                    result <= {r, q};
                    res_valid <= 1'b1;
                    busy <= 1'b0;
                end
            end
        end
    end
endmodule