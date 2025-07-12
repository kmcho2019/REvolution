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

reg [3:0] cnt;          // 0-8 counter (8 cycles needed)
reg [16:0] SR;          // Extended shift register [remainder|quotient|carry]
reg quotient_sign;      // Final quotient sign
reg remainder_sign;     // Final remainder sign
reg [7:0] divisor_abs;  // Absolute value of divisor
reg [7:0] dividend_abs; // Absolute value of dividend

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt <= 0;
        SR <= 0;
        res_valid <= 0;
        result <= 0;
        quotient_sign <= 0;
        remainder_sign <= 0;
    end else begin
        if (cnt != 0) begin  // Calculation in progress
            // Perform subtraction and shift
            if (SR[15:8] >= divisor_abs) begin
                SR <= {SR[15:8] - divisor_abs, SR[7:0], 1'b1};
            end else begin
                SR <= {SR[15:0], 1'b0};
            end

            if (cnt == 4'd8) begin
                // Final result assembly
                if (divisor == 0) begin
                    result <= 16'hFFFF;  // Division by zero
                end else begin
                    // Handle signed results
                    reg [7:0] rem = SR[15:8];
                    reg [7:0] quo = SR[7:0];
                    
                    if (sign) begin
                        rem = remainder_sign ? -rem : rem;
                        quo = quotient_sign ? -quo : quo;
                    end
                    
                    result <= {rem, quo};
                end
                res_valid <= 1;
                cnt <= 0;
            end else begin
                cnt <= cnt + 1;
            end
        end else if (opn_valid && !res_valid) begin
            // Initialize operation
            if (sign) begin
                quotient_sign = dividend[7] ^ divisor[7];
                remainder_sign = dividend[7];
                dividend_abs = dividend[7] ? -dividend : dividend;
                divisor_abs = divisor[7] ? -divisor : divisor;
            end else begin
                quotient_sign = 0;
                remainder_sign = 0;
                dividend_abs = dividend;
                divisor_abs = divisor;
            end
            
            SR <= {8'b0, dividend_abs, 1'b0};
            cnt <= 1;
            res_valid <= 0;
        end else if (!opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule