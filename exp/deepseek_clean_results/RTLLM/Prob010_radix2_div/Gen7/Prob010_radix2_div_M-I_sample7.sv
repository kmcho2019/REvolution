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

// Internal registers
reg [7:0] abs_dividend, abs_divisor;
reg dividend_neg, divisor_neg;
reg [7:0] partial_remainder, partial_quotient;
reg [3:0] iteration;
reg calculating;
reg div_by_zero;

// Early termination signals
wire power_of_two = (abs_divisor & (abs_divisor - 1)) == 0;
wire early_complete = (partial_remainder == 0) || (power_of_two && (iteration > $clog2(abs_divisor)));

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        calculating <= 0;
        div_by_zero <= 0;
    end else begin
        // Input processing stage
        if (opn_valid && !calculating) begin
            // Handle signed conversion
            dividend_neg <= sign & dividend[7];
            divisor_neg <= sign & divisor[7];
            abs_dividend <= (sign & dividend[7]) ? -dividend : dividend;
            abs_divisor <= (sign & divisor[7]) ? -divisor : divisor;
            
            // Check for division by zero
            div_by_zero <= (divisor == 0);
            
            // Initialize calculation
            partial_remainder <= (sign & dividend[7]) ? -dividend : dividend;
            partial_quotient <= 0;
            iteration <= 0;
            calculating <= 1;
            res_valid <= 0;
        end
        
        // Calculation stage
        if (calculating) begin
            if (div_by_zero) begin
                // Handle division by zero
                result <= {8'hFF, 8'hFF}; // All ones as error indicator
                res_valid <= 1;
                calculating <= 0;
            end else if (early_complete || iteration == 7) begin
                // Finalize result with sign correction
                result[15:8] <= dividend_neg ? -partial_remainder : partial_remainder;
                result[7:0] <= (dividend_neg ^ divisor_neg) ? -partial_quotient : partial_quotient;
                res_valid <= 1;
                calculating <= 0;
            end else begin
                // Radix-2 division step
                if (partial_remainder >= abs_divisor) begin
                    partial_remainder <= partial_remainder - abs_divisor;
                    partial_quotient <= (partial_quotient << 1) | 1'b1;
                end else begin
                    partial_quotient <= partial_quotient << 1;
                end
                iteration <= iteration + 1;
            end
        end else begin
            res_valid <= 0;
        end
    end
end

endmodule