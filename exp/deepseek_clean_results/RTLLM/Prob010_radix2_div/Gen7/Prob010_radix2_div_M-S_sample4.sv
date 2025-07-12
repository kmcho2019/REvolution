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
reg dividend_neg, divisor_neg;
reg [7:0] quotient;
reg [7:0] partial_rem;
reg [3:0] cnt;
reg running;

wire [8:0] sub_result = {partial_rem, quotient[7]} + {1'b0, abs_divisor};
wire carry_out = sub_result[8];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        running <= 0;
    end else begin
        res_valid <= 0;
        
        if (opn_valid && !running) begin
            // Handle signed operation
            abs_dividend <= (sign & dividend[7]) ? -dividend : dividend;
            abs_divisor <= (sign & divisor[7]) ? -divisor : divisor;
            dividend_neg <= sign & dividend[7];
            divisor_neg <= sign & divisor[7];
            
            // Initialize division
            quotient <= 0;
            partial_rem <= 0;
            cnt <= 0;
            running <= (divisor != 0); // Start if not division by zero
            
            // Handle division by zero
            if (divisor == 0) begin
                result <= {8'hFF, 8'hFF};
                res_valid <= 1;
            end
        end
        
        if (running) begin
            if (cnt < 8) begin
                // Non-restoring division step
                if (partial_rem[7]) begin
                    // Add when remainder is negative
                    {partial_rem, quotient} <= {partial_rem + abs_divisor, quotient[6:0], 1'b0};
                end else begin
                    // Subtract when remainder is positive
                    {partial_rem, quotient} <= {sub_result[7:0], quotient[6:0], ~carry_out};
                end
                cnt <= cnt + 1;
            end else begin
                // Final correction step
                if (partial_rem[7]) begin
                    partial_rem <= partial_rem + abs_divisor;
                    quotient <= quotient - 1;
                end
                
                // Apply signs to results
                result[15:8] <= dividend_neg ? -partial_rem : partial_rem;
                result[7:0] <= (dividend_neg ^ divisor_neg) ? -quotient : quotient;
                
                res_valid <= 1;
                running <= 0;
            end
        end
    end
end

endmodule