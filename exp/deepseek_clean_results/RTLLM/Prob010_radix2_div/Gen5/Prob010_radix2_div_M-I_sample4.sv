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

reg [15:0] SR;          // Shift register (remainder[15:8] + quotient[7:0])
reg [7:0] NEG_DIVISOR;  // Negative of absolute divisor
reg [7:0] abs_divisor;  // Absolute value of divisor
reg [3:0] cnt;         // Iteration counter
reg start_cnt;         // Division process active
reg dividend_sign;     // Original sign of dividend
reg divisor_sign;      // Original sign of divisor

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        SR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        NEG_DIVISOR <= 0;
        abs_divisor <= 0;
        dividend_sign <= 0;
        divisor_sign <= 0;
    end else begin
        if (opn_valid && !res_valid && !start_cnt) begin
            // Capture inputs and initialize
            dividend_sign <= sign & dividend[7];
            divisor_sign <= sign & divisor[7];
            
            // Take absolute values
            abs_divisor <= (sign & divisor[7]) ? -divisor : divisor;
            NEG_DIVISOR <= -((sign & divisor[7]) ? -divisor : divisor);
            
            // Initialize shift register with dividend (left shifted by 1)
            SR <= {(sign & dividend[7]) ? -dividend : dividend, 8'b0} << 1;
            
            cnt <= 0;
            start_cnt <= (abs_divisor != 0); // Start only if divisor non-zero
            res_valid <= 0;
            
            // Handle division by zero
            if (abs_divisor == 0) begin
                result <= {8'hFF, 8'hFF};
                res_valid <= 1;
            end
        end else if (start_cnt) begin
            // Division iteration
            if (cnt < 8) begin
                // Perform subtraction
                if (SR[15:8] >= abs_divisor) begin
                    SR <= {SR[15:8] + NEG_DIVISOR, SR[7:0]} << 1 | 1;
                end else begin
                    SR <= SR << 1;
                end
                
                cnt <= cnt + 1;
            end
            
            // Finalize after 8 iterations
            if (cnt == 7) begin
                // Correct negative remainder
                if (SR[15]) begin
                    SR[15:8] <= SR[15:8] + abs_divisor;
                    SR[0] <= 0; // Adjust LSB of quotient
                end
                
                // Apply signs to final result
                result[15:8] <= dividend_sign ? -SR[15:8] : SR[15:8]; // Remainder
                result[7:0] <= (dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0]; // Quotient
                
                res_valid <= 1;
                start_cnt <= 0;
            end
        end else begin
            // Clear valid flag when result is consumed
            res_valid <= 0;
        end
    end
end

endmodule