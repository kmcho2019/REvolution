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
    reg [4:0] cnt;
    reg start_cnt;
    reg [16:0] SR; // Shift register: [16:9] remainder, [8:1] quotient, [0] temp
    reg [7:0] NEG_DIVISOR;
    reg dividend_sign;
    reg divisor_sign;
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 1'b0;
            result <= 16'b0;
            cnt <= 5'b0;
            start_cnt <= 1'b0;
            SR <= 17'b0;
            NEG_DIVISOR <= 8'b0;
            dividend_reg <= 8'b0;
            divisor_reg <= 8'b0;
            sign_reg <= 1'b0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
        end else begin
            if (opn_valid && !res_valid && !start_cnt) begin
                // Capture inputs and start operation
                sign_reg <= sign;
                
                // Handle signed division
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
                
                dividend_reg <= abs_dividend;
                divisor_reg <= abs_divisor;
                NEG_DIVISOR <= -abs_divisor;
                SR <= {9'b0, abs_dividend, 1'b0}; // Initialize shift register
                cnt <= 5'b1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end

            if (start_cnt) begin
                if (cnt[3]) begin // cnt == 8
                    // Division complete
                    start_cnt <= 1'b0;
                    cnt <= 5'b0;
                    
                    // Handle sign correction
                    if (sign_reg) begin
                        // Quotient sign is dividend_sign XOR divisor_sign
                        if (dividend_sign ^ divisor_sign) begin
                            SR[8:1] <= -SR[8:1]; // Negate quotient
                        end
                        
                        // Remainder sign is dividend_sign
                        if (dividend_sign) begin
                            SR[16:9] <= -SR[16:9]; // Negate remainder
                        end
                    end
                    
                    result <= {SR[16:9], SR[8:1]}; // {remainder, quotient}
                    res_valid <= 1'b1;
                end else begin
                    // Perform one division step
                    if (SR[16:9] + NEG_DIVISOR >= 0) begin
                        SR <= {SR[16:9] + NEG_DIVISOR, SR[7:0], 1'b1};
                    end else begin
                        SR <= {SR[15:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end

            // Clear valid when result is consumed
            if (res_valid && opn_valid) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule