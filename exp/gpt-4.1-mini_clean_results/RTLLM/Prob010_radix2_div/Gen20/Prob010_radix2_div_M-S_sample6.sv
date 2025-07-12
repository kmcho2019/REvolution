module radix2_div (
    input              clk,
    input              rst,
    input              sign,
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result
);

reg [3:0] cnt;
reg start_cnt;

reg [7:0] abs_dividend, abs_divisor;
reg dividend_neg, divisor_neg;
reg quotient_neg, remainder_neg;

reg [16:0] SR; // [16:9] remainder (9 bits), [8:1] quotient (8 bits), [0] unused

wire [8:0] rem = SR[16:8];
wire [8:0] sub_val = {1'b0, abs_divisor};
wire [9:0] sub_res = {1'b0, rem} - {1'b0, sub_val};
wire borrow = sub_res[9];

// Compute absolute values and signs on opn_valid
function [7:0] abs_val;
    input [7:0] in;
    input       is_signed;
    begin
        abs_val = (is_signed && in[7]) ? (~in + 1'b1) : in;
    end
endfunction

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt         <= 4'd0;
        start_cnt   <= 1'b0;
        res_valid   <= 1'b0;
        result      <= 16'd0;
        abs_dividend <= 8'd0;
        abs_divisor <= 8'd0;
        dividend_neg <= 1'b0;
        divisor_neg  <= 1'b0;
        quotient_neg <= 1'b0;
        remainder_neg<= 1'b0;
        SR          <= 17'd0;
    end else begin
        if (opn_valid && !start_cnt && !res_valid) begin
            // Latch inputs and prepare for division
            abs_dividend <= abs_val(dividend, sign);
            abs_divisor  <= abs_val(divisor, sign);
            dividend_neg <= sign && dividend[7];
            divisor_neg  <= sign && divisor[7];
            quotient_neg <= sign && (dividend[7] ^ divisor[7]);
            remainder_neg<= sign && dividend[7];
            cnt         <= 4'd1;
            start_cnt   <= 1'b1;
            res_valid   <= 1'b0;
            // Initialize SR: remainder = abs_dividend shifted left by 1, quotient zero
            // SR = {remainder[8:0], quotient[7:0]} => remainder 9 bits with LSB=0 for shifting
            SR <= {abs_val(dividend, sign), 1'b0, 8'd0};
        end else if (start_cnt) begin
            if (cnt == 4'd8) begin
                // Division done
                start_cnt <= 1'b0;
                cnt <= 4'd0;
                // Prepare quotient and remainder
                reg [7:0] quotient, remainder;

                if (abs_divisor == 0) begin
                    quotient = 8'd0;
                    remainder= abs_dividend;
                end else begin
                    quotient = SR[8:1];
                    remainder= SR[16:9];
                    if (borrow) begin
                        // If last subtraction was invalid, remainder = previous remainder (SR[16:9]) (already)
                        // quotient bit = 0 (already)
                    end
                end

                // Adjust signs if signed
                if (quotient_neg) quotient = (~quotient + 1'b1);
                if (remainder_neg) remainder = (~remainder + 1'b1);

                result <= {remainder, quotient};
                res_valid <= 1'b1;
            end else begin
                // Division step
                cnt <= cnt + 1'b1;
                if (abs_divisor == 0) begin
                    // Division by zero: just keep SR
                    SR <= SR;
                end else if (!borrow) begin
                    // Subtraction success: remainder = sub_res[8:0], quotient bit = 1
                    SR <= {sub_res[8:0], SR[7:1], 1'b1};
                end else begin
                    // Subtraction fail: remainder unchanged, quotient bit = 0
                    SR <= {rem, SR[7:1], 1'b0};
                end
            end
        end else if (res_valid && !opn_valid) begin
            // Clear res_valid after result consumption
            res_valid <= 1'b0;
        end
    end
end

endmodule