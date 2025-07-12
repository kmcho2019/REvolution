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

// Pipeline registers
reg [7:0] dividend_abs, divisor_abs;
reg dividend_sign, divisor_sign;
reg div_by_zero, power_of_two;
reg [2:0] shift_amount;
reg pipeline_valid;

// Calculation registers
reg [7:0] remainder, quotient;
reg [3:0] cnt;
reg calculating;

// Early termination detection
wire [7:0] divisor_msb = divisor_abs & ~(divisor_abs - 1);
wire remainder_zero = (remainder == 0);

// Main pipeline control
always @(posedge clk or posedge rst) begin
    if (rst) begin
        pipeline_valid <= 0;
        res_valid <= 0;
        calculating <= 0;
        cnt <= 0;
    end else begin
        // Input stage
        if (opn_valid && !pipeline_valid) begin
            dividend_sign <= sign & dividend[7];
            divisor_sign <= sign & divisor[7];
            dividend_abs <= (sign & dividend[7]) ? -dividend : dividend;
            divisor_abs <= (sign & divisor[7]) ? -divisor : divisor;
            div_by_zero <= (divisor == 0);
            power_of_two <= (divisor != 0) && ((divisor & (divisor - 1)) == 0);
            shift_amount <= divisor_msb[7] ? 3'd7 :
                           divisor_msb[6] ? 3'd6 :
                           divisor_msb[5] ? 3'd5 :
                           divisor_msb[4] ? 3'd4 :
                           divisor_msb[3] ? 3'd3 :
                           divisor_msb[2] ? 3'd2 :
                           divisor_msb[1] ? 3'd1 : 3'd0;
            pipeline_valid <= 1;
        end

        // Calculation stage
        if (pipeline_valid) begin
            if (!calculating) begin
                // Initialize calculation
                remainder <= dividend_abs;
                quotient <= 0;
                cnt <= 0;
                calculating <= 1;
            end else begin
                // Radix-2 step
                if (remainder >= divisor_abs) begin
                    remainder <= remainder - divisor_abs;
                    quotient <= (quotient << 1) | 1'b1;
                end else begin
                    quotient <= quotient << 1;
                end
                
                // Early termination check
                if (remainder_zero || (power_of_two && cnt >= shift_amount)) begin
                    pipeline_valid <= 0;
                    calculating <= 0;
                    // Final result assembly
                    result[15:8] <= dividend_sign ? -remainder : remainder;
                    result[7:0] <= (dividend_sign ^ divisor_sign) ? -quotient : quotient;
                    res_valid <= 1;
                end else if (cnt == 7) begin
                    pipeline_valid <= 0;
                    calculating <= 0;
                    // Final result assembly
                    result[15:8] <= dividend_sign ? -remainder : remainder;
                    result[7:0] <= (dividend_sign ^ divisor_sign) ? -quotient : quotient;
                    res_valid <= 1;
                end else begin
                    cnt <= cnt + 1;
                end
            end
        end else begin
            res_valid <= 0;
        end
    end
end

endmodule