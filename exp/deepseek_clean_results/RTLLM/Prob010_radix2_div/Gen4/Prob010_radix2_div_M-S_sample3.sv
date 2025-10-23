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
reg [7:0] remainder, quotient;
reg [3:0] cnt;
reg running;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        running <= 0;
    end else begin
        if (opn_valid && !running && !res_valid) begin
            // Handle signed inputs
            dividend_sign = sign & dividend[7];
            divisor_sign = sign & divisor[7];
            abs_dividend = dividend_sign ? -dividend : dividend;
            abs_divisor = divisor_sign ? -divisor : divisor;
            
            // Initialize division
            remainder = abs_dividend;
            quotient = 0;
            cnt = 0;
            running = 1;
            res_valid = 0;
            
            // Handle division by zero
            if (abs_divisor == 0) begin
                result = {8'hFF, 8'hFF};
                res_valid = 1;
                running = 0;
            end
        end else if (running) begin
            // Division iteration
            if (remainder >= abs_divisor) begin
                remainder = remainder - abs_divisor;
                quotient = {quotient[6:0], 1'b1};
            end else begin
                quotient = {quotient[6:0], 1'b0};
            end
            
            remainder = {remainder[6:0], quotient[7]};
            
            // Check completion
            if (cnt == 7) begin
                // Correct remainder if negative
                if (remainder[7]) begin
                    remainder = remainder + abs_divisor;
                    quotient = quotient - 1;
                end
                
                // Apply signs
                remainder = dividend_sign ? -remainder : remainder;
                quotient = (dividend_sign ^ divisor_sign) ? -quotient : quotient;
                
                result = {remainder, quotient};
                res_valid = 1;
                running = 0;
            end
            cnt = cnt + 1;
        end else begin
            res_valid = 0;
        end
    end
end

endmodule