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

reg [7:0] dividend_abs, divisor_abs;
reg dividend_sign, divisor_sign;
reg [7:0] remainder, quotient;
reg [3:0] cnt;
reg running;
wire [7:0] divisor_neg = -divisor_abs;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        running <= 0;
        result <= 0;
    end else begin
        res_valid <= 0;
        
        if (opn_valid && !running && !res_valid) begin
            // Handle signed conversion
            dividend_sign <= sign & dividend[7];
            divisor_sign <= sign & divisor[7];
            dividend_abs <= (sign & dividend[7]) ? -dividend : dividend;
            divisor_abs <= (sign & divisor[7]) ? -divisor : divisor;
            
            // Initialize division
            if (divisor == 0) begin
                // Division by zero
                result <= {8'hFF, 8'hFF};
                res_valid <= 1;
            end else begin
                remainder <= dividend_abs;
                quotient <= 0;
                cnt <= 0;
                running <= 1;
            end
        end else if (running) begin
            // Division iteration
            if (remainder >= divisor_abs) begin
                remainder <= remainder - divisor_abs;
                quotient <= {quotient[6:0], 1'b1};
            end else begin
                quotient <= {quotient[6:0], 1'b0};
            end
            
            remainder <= {remainder[6:0], quotient[7]};
            
            if (cnt == 7) begin
                // Final remainder adjustment
                if (remainder[7]) begin
                    remainder <= remainder + divisor_abs;
                    quotient <= quotient - 1;
                end
                
                // Apply signs
                remainder <= dividend_sign ? -remainder : remainder;
                quotient <= (dividend_sign ^ divisor_sign) ? -quotient : quotient;
                
                result <= {remainder, quotient};
                res_valid <= 1;
                running <= 0;
            end
            
            cnt <= cnt + 1;
        end
    end
end

endmodule