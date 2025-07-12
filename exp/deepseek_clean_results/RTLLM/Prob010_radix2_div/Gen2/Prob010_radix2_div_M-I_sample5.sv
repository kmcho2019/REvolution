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

parameter WIDTH = 8;
reg [15:0] SR;  // Shift register: [remainder|quotient]
reg [3:0] cnt;  // 0=idle, 1-8=processing
reg [WIDTH-1:0] abs_divisor;
reg [WIDTH-1:0] NEG_DIVISOR;
reg dividend_sign, divisor_sign;
reg [WIDTH-1:0] abs_dividend;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        SR <= 0;
        abs_divisor <= 0;
        NEG_DIVISOR <= 0;
        dividend_sign <= 0;
        divisor_sign <= 0;
        abs_dividend <= 0;
    end else begin
        // Clear result valid when new operation starts
        if (opn_valid) res_valid <= 0;

        // Start new division
        if (opn_valid && !cnt) begin
            // Compute absolute values and signs
            dividend_sign <= sign & dividend[WIDTH-1];
            divisor_sign <= sign & divisor[WIDTH-1];
            abs_dividend <= dividend_sign ? -dividend : dividend;
            abs_divisor <= divisor_sign ? -divisor : divisor;
            NEG_DIVISOR <= -abs_divisor;

            // Initialize shift register
            SR <= {WIDTH'b0, abs_dividend} << 1;
            cnt <= 1;
        end

        // Division steps
        if (cnt && cnt < 9) begin
            // Perform subtraction
            if (SR[15]) 
                SR[15:8] <= SR[15:8] + abs_divisor;
            else
                SR[15:8] <= SR[15:8] + NEG_DIVISOR;

            // Shift and set LSB
            SR <= {SR[14:0], ~SR[15]};
            cnt <= cnt + 1;

            // Final step (cnt == 8)
            if (cnt == 8) begin
                // Final remainder adjustment
                if (SR[15]) SR[15:8] <= SR[15:8] + abs_divisor;

                // Correct quotient and apply signs if needed
                reg [WIDTH-1:0] quotient = {SR[6:0], ~SR[15]};
                reg [WIDTH-1:0] remainder = SR[15:8];

                if (sign) begin
                    quotient = (dividend_sign ^ divisor_sign) ? -quotient : quotient;
                    remainder = dividend_sign ? -remainder : remainder;
                end

                result <= {remainder, quotient};
                res_valid <= 1;
                cnt <= 0;
            end
        end
    end
end

endmodule