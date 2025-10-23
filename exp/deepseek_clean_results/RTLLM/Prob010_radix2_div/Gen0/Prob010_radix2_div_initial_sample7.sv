module radix2_div (
    input wire clk,
    input wire rst,
    input wire sign,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    input wire opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg sign_reg;
reg [15:0] SR;           // Shift register (remainder | quotient)
reg [7:0] NEG_DIVISOR;    // Negative of absolute divisor
reg [3:0] cnt;            // Iteration counter (0-8)
reg start_cnt;            // Division in progress flag
reg quotient_sign;        // Final quotient sign
reg remainder_sign;       // Final remainder sign

wire [8:0] sub_result = {1'b0, SR[15:8]} + {1'b0, NEG_DIVISOR};
wire carry_out = ~sub_result[8];  // 1 if no borrow (SR >= divisor)

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 16'b0;
        SR <= 16'b0;
        cnt <= 0;
        start_cnt <= 0;
        sign_reg <= 0;
        quotient_sign <= 0;
        remainder_sign <= 0;
    end else begin
        if (opn_valid && !res_valid && !start_cnt) begin
            // Capture inputs and initialize
            sign_reg <= sign;
            dividend_reg <= dividend;
            divisor_reg <= divisor;
            
            // Handle signed division
            if (sign) begin
                quotient_sign <= dividend[7] ^ divisor[7];
                remainder_sign <= dividend[7];
                dividend_reg <= dividend[7] ? -dividend : dividend;
                divisor_reg <= divisor[7] ? -divisor : divisor;
            end else begin
                quotient_sign <= 0;
                remainder_sign <= 0;
            end
            
            NEG_DIVISOR <= -divisor_reg;
            SR <= {8'b0, dividend_reg} << 1;
            cnt <= 0;
            start_cnt <= 1;
            res_valid <= 0;
        end
        
        if (start_cnt) begin
            if (cnt == 8) begin
                // Division complete
                start_cnt <= 0;
                cnt <= 0;
                
                // Final remainder adjustment
                if (!carry_out) begin
                    SR[15:8] <= SR[15:8] + divisor_reg;
                end
                
                // Apply sign correction
                if (sign_reg) begin
                    SR[7:0] <= quotient_sign ? -SR[7:0] : SR[7:0];
                    SR[15:8] <= remainder_sign ? -SR[15:8] : SR[15:8];
                end
                
                result <= SR;
                res_valid <= 1;
            end else begin
                // Perform one division step
                if (carry_out) begin
                    SR <= {sub_result[7:0], SR[7:1], 1'b1};
                end else begin
                    SR <= {SR[15:8], SR[7:1], 1'b0};
                end
                cnt <= cnt + 1;
            end
        end
        
        // Clear valid when result is consumed
        if (res_valid && opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule