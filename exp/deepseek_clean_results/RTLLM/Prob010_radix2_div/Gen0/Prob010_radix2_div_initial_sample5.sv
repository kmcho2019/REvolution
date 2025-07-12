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

reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg dividend_sign;
reg divisor_sign;
reg [15:0] SR;  // Shift register: [15:8] remainder, [7:0] quotient
reg [7:0] NEG_DIVISOR;
reg [3:0] cnt;
reg start_cnt;
reg [7:0] original_dividend;
reg [7:0] original_divisor;

wire [8:0] sub_result = {SR[15:8], 1'b0} + {1'b0, NEG_DIVISOR};
wire carry_out = ~sub_result[8];  // Invert because we're adding negative

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        cnt <= 4'd0;
        start_cnt <= 1'b0;
        SR <= 16'd0;
        result <= 16'd0;
    end else begin
        if (opn_valid && !res_valid && !start_cnt) begin
            // Capture inputs and compute absolute values
            original_dividend <= dividend;
            original_divisor <= divisor;
            
            if (sign) begin
                dividend_sign <= dividend[7];
                divisor_sign <= divisor[7];
                abs_dividend <= dividend[7] ? -dividend : dividend;
                abs_divisor <= divisor[7] ? -divisor : divisor;
            end else begin
                dividend_sign <= 1'b0;
                divisor_sign <= 1'b0;
                abs_dividend <= dividend;
                abs_divisor <= divisor;
            end
            
            NEG_DIVISOR <= -abs_divisor;
            SR <= {8'd0, abs_dividend} << 1;
            cnt <= 4'd1;
            start_cnt <= 1'b1;
            res_valid <= 1'b0;
        end
        
        if (start_cnt) begin
            if (cnt[3]) begin  // cnt == 8
                // Final result processing
                start_cnt <= 1'b0;
                cnt <= 4'd0;
                
                // Handle negative remainder if needed
                if (SR[15]) begin
                    SR[15:8] <= SR[15:8] + abs_divisor;
                end
                
                // Apply sign correction
                if (sign) begin
                    // Quotient sign: dividend_sign XOR divisor_sign
                    if (dividend_sign ^ divisor_sign) begin
                        SR[7:0] <= -SR[7:0];
                    end
                    
                    // Remainder sign: dividend_sign
                    if (dividend_sign) begin
                        SR[15:8] <= -SR[15:8];
                    end
                end
                
                result <= SR;
                res_valid <= 1'b1;
            end else begin
                // Division step
                cnt <= cnt + 1;
                
                if (carry_out) begin
                    SR <= {sub_result[7:0], SR[7:0], 1'b1};
                end else begin
                    SR <= {SR[14:0], 1'b0};
                end
            end
        end
        
        // Clear valid when result is consumed
        if (res_valid && opn_valid) begin
            res_valid <= 1'b0;
        end
    end
end

endmodule