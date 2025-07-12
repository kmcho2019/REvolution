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

reg [16:0] SR;          // Shift register (1 extra bit for carry)
reg [7:0] NEG_DIVISOR;  // Negative of absolute divisor
reg [3:0] cnt;          // Iteration counter
reg start_cnt;          // Division active flag
reg dividend_sign;      // Sign of dividend
reg divisor_sign;       // Sign of divisor
reg [7:0] abs_dividend; // Absolute value of dividend
reg [7:0] abs_divisor;  // Absolute value of divisor

always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        result <= 0;
        dividend_sign <= 0;
        divisor_sign <= 0;
        abs_dividend <= 0;
        abs_divisor <= 0;
    end else begin
        if (opn_valid && !res_valid && !start_cnt) begin
            // Capture inputs and compute absolute values
            dividend_sign = sign & dividend[7];
            divisor_sign = sign & divisor[7];
            abs_dividend = dividend_sign ? -dividend : dividend;
            abs_divisor = divisor_sign ? -divisor : divisor;
            
            // Handle division by zero
            if (abs_divisor == 0) begin
                result <= {8'hFF, 8'hFF};
                res_valid <= 1;
            end else begin
                // Initialize shift register (dividend << 1)
                SR <= {1'b0, abs_dividend, 8'b0};
                NEG_DIVISOR <= -abs_divisor;
                cnt <= 0;
                start_cnt <= 1;
                res_valid <= 0;
            end
        end else if (start_cnt) begin
            // Division iteration
            if (cnt == 8) begin
                // Division complete
                start_cnt <= 0;
                
                // Correct negative remainder if needed
                if (SR[16]) begin
                    SR[16:8] <= SR[16:8] + abs_divisor;
                    SR[7:0] <= SR[7:0] - 1;
                end
                
                // Apply signs to results
                if (dividend_sign) SR[16:8] <= -SR[16:8];
                if (dividend_sign ^ divisor_sign) SR[7:0] <= -SR[7:0];
                
                // Output final result
                result <= {SR[16:9], SR[7:0]};
                res_valid <= 1;
            end else begin
                // Perform subtraction and shift
                SR[16:8] <= SR[15:8] + NEG_DIVISOR;
                SR <= {SR[15:0], ~SR[16]}; // Shift left with carry-in
                cnt <= cnt + 1;
            end
        end else if (res_valid && opn_valid) begin
            // Clear valid when new operation starts
            res_valid <= 0;
        end
    end
end

endmodule