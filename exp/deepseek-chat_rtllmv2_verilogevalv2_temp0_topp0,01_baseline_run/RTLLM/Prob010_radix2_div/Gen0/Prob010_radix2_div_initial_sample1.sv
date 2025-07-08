module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [7:0] abs_dividend, abs_divisor;
reg dividend_sign, divisor_sign;
reg [15:0] SR;  // Shift register: [remainder|quotient]
reg [7:0] NEG_DIVISOR;
reg [3:0] cnt;
reg start_cnt;
reg [7:0] final_quotient, final_remainder;

// Input processing and initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 16'b0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        abs_dividend <= 8'b0;
        abs_divisor <= 8'b0;
        dividend_sign <= 0;
        divisor_sign <= 0;
        NEG_DIVISOR <= 8'b0;
    end
    else begin
        if (opn_valid && !res_valid && !start_cnt) begin
            // Capture inputs and compute absolute values
            dividend_sign <= sign & dividend[7];
            divisor_sign <= sign & divisor[7];
            abs_dividend <= dividend_sign ? -dividend : dividend;
            abs_divisor <= divisor_sign ? -divisor : divisor;
            NEG_DIVISOR <= -(divisor_sign ? -divisor : divisor);
            
            // Initialize shift register (dividend << 1)
            SR <= {8'b0, abs_dividend} << 1;
            cnt <= 1;
            start_cnt <= 1;
            res_valid <= 0;
        end
        else if (start_cnt) begin
            if (cnt[3]) begin  // cnt == 8
                // Division complete
                start_cnt <= 0;
                cnt <= 0;
                
                // Extract final remainder (upper 8 bits) and quotient (lower 8 bits)
                final_remainder <= SR[15:8] >> 1;
                final_quotient <= SR[7:0];
                
                // Sign correction
                if (sign) begin
                    final_quotient <= (dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0];
                    final_remainder <= dividend_sign ? -SR[15:8] >> 1 : SR[15:8] >> 1;
                end
                
                res_valid <= 1;
                result <= {final_remainder, final_quotient};
            end
            else begin
                // Perform one division step
                if (SR[15:8] + NEG_DIVISOR >= 0) begin
                    SR <= {SR[15:8] + NEG_DIVISOR, SR[7:0], 1'b1};
                end
                else begin
                    SR <= {SR[15:8], SR[7:0], 1'b0};
                end
                cnt <= cnt + 1;
            end
        end
        else if (res_valid && opn_valid) begin
            // Clear valid when new operation starts
            res_valid <= 0;
        end
    end
end

endmodule