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
reg [7:0] NEG_DIVISOR;
reg [15:0] SR;  // Shift register: [remainder|quotient]
reg [3:0] cnt;
reg start_cnt;
reg dividend_sign, divisor_sign;
reg [7:0] original_dividend, original_divisor;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        start_cnt <= 0;
        SR <= 0;
        abs_dividend <= 0;
        abs_divisor <= 0;
        NEG_DIVISOR <= 0;
        dividend_sign <= 0;
        divisor_sign <= 0;
        original_dividend <= 0;
        original_divisor <= 0;
    end else begin
        if (opn_valid && !res_valid && !start_cnt) begin
            // Capture inputs and compute absolute values
            original_dividend <= dividend;
            original_divisor <= divisor;
            
            dividend_sign <= sign & dividend[7];
            divisor_sign <= sign & divisor[7];
            
            abs_dividend <= dividend_sign ? -dividend : dividend;
            abs_divisor <= divisor_sign ? -divisor : divisor;
            NEG_DIVISOR <= divisor_sign ? divisor : -divisor;
            
            SR <= {8'b0, abs_dividend} << 1;
            cnt <= 1;
            start_cnt <= 1;
            res_valid <= 0;
        end
        
        if (start_cnt) begin
            if (cnt[3]) begin  // cnt == 8
                // Final remainder adjustment
                if (SR[15]) begin
                    SR[15:8] <= SR[15:8] + abs_divisor;
                end
                
                // Correct quotient
                SR[7:0] <= SR[7:0] >> 1;
                if (SR[15]) begin
                    SR[0] <= 0;
                end else begin
                    SR[0] <= 1;
                end
                
                // Apply sign correction if signed operation
                if (sign) begin
                    SR[7:0] <= (dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0];
                    SR[15:8] <= dividend_sign ? -SR[15:8] : SR[15:8];
                end
                
                result <= SR;
                res_valid <= 1;
                start_cnt <= 0;
                cnt <= 0;
            end else begin
                // Perform subtraction and shift
                if (SR[15]) begin
                    SR[15:8] <= SR[15:8] + abs_divisor;
                end else begin
                    SR[15:8] <= SR[15:8] + NEG_DIVISOR;
                end
                
                // Shift left and set LSB based on carry
                SR <= SR << 1;
                SR[0] <= ~SR[15];
                
                cnt <= cnt + 1;
            end
        end
        
        // Clear res_valid when result is read
        if (res_valid && opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule