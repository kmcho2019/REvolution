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

reg [15:0] SR;  // Shift register: [remainder|quotient]
reg [3:0] cnt;   // 0=idle, 1-8=processing
reg [7:0] abs_divisor;
reg [7:0] NEG_DIVISOR;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        SR <= 0;
    end else begin
        // Clear result valid when new operation starts
        if (opn_valid) res_valid <= 0;

        // Start new division
        if (opn_valid && !cnt) begin
            // Compute absolute values and signs
            reg dividend_sign = sign & dividend[7];
            reg divisor_sign = sign & divisor[7];
            reg [7:0] abs_dividend = dividend_sign ? -dividend : dividend;
            abs_divisor = divisor_sign ? -divisor : divisor;
            NEG_DIVISOR = -abs_divisor;

            // Initialize shift register
            SR <= {8'b0, abs_dividend} << 1;
            cnt <= 1;
        end

        // Division steps
        if (cnt && cnt < 9) begin
            // Perform subtraction
            SR[15:8] <= SR[15] ? (SR[15:8] + abs_divisor) 
                               : (SR[15:8] + NEG_DIVISOR);

            // Shift and set LSB
            SR <= {SR[14:0], ~SR[15]};
            cnt <= cnt + 1;

            // Final step (cnt == 8)
            if (cnt == 8) begin
                // Final remainder adjustment
                if (SR[15]) SR[15:8] <= SR[15:8] + abs_divisor;

                // Correct quotient and apply signs if needed
                reg [7:0] quotient = {SR[6:0], ~SR[15]};
                reg [7:0] remainder = SR[15:8];

                if (sign) begin
                    reg dividend_sign = dividend[7];
                    reg divisor_sign = divisor[7];
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