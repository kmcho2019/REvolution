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

// Pipeline registers
reg [7:0] dividend_abs, divisor_abs;
reg dividend_sign, divisor_sign;
reg div_by_zero, div_by_one;
reg [2:0] power_of_two;
reg stage1_valid;

// Division engine
reg [7:0] remainder;
reg [7:0] quotient;
reg [3:0] cnt;
reg running;

// Constants
wire [7:0] divisor_neg = -divisor_abs;
wire [7:0] dividend_neg = -dividend;

// Early termination detection
wire is_power_of_two = (divisor_abs & (divisor_abs - 1)) == 0;
wire [2:0] shift_amount = 
    divisor_abs[0] ? 0 :
    divisor_abs[1] ? 1 :
    divisor_abs[2] ? 2 :
    divisor_abs[3] ? 3 :
    divisor_abs[4] ? 4 :
    divisor_abs[5] ? 5 :
    divisor_abs[6] ? 6 : 7;

// Carry-save addition
wire [8:0] sum = {1'b0, remainder} + {1'b0, divisor_neg};
wire carry_out = sum[8];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all registers
        stage1_valid <= 0;
        res_valid <= 0;
        running <= 0;
        result <= 0;
    end else begin
        // Default assignments
        res_valid <= 0;
        
        // Pipeline Stage 1: Input processing
        if (opn_valid && !res_valid) begin
            // Calculate absolute values and signs
            dividend_sign <= sign & dividend[7];
            divisor_sign <= sign & divisor[7];
            dividend_abs <= (sign & dividend[7]) ? dividend_neg : dividend;
            divisor_abs <= (sign & divisor[7]) ? -divisor : divisor;
            
            // Special case detection
            div_by_zero <= (divisor == 0);
            div_by_one <= (divisor_abs == 1);
            power_of_two <= is_power_of_two ? shift_amount : 3'b0;
            
            stage1_valid <= 1;
        end else begin
            stage1_valid <= 0;
        end

        // Pipeline Stage 2: Division core
        if (stage1_valid) begin
            if (div_by_zero) begin
                // Handle division by zero
                result <= {8'hFF, 8'hFF};
                res_valid <= 1;
            end else if (div_by_one) begin
                // Handle division by ±1
                result <= {8'b0, (dividend_sign ^ divisor_sign) ? dividend_neg : dividend_abs};
                res_valid <= 1;
            end else if (is_power_of_two) begin
                // Handle power-of-two divisors
                remainder <= dividend_abs % divisor_abs;
                quotient <= dividend_abs >> shift_amount;
                res_valid <= 1;
            end else begin
                // Initialize for normal division
                remainder <= dividend_abs;
                quotient <= 0;
                cnt <= 0;
                running <= 1;
            end
        end else if (running) begin
            // Non-restoring division iteration
            if (carry_out) begin
                {remainder, quotient} <= {sum[7:0], quotient, 1'b1};
            end else begin
                {remainder, quotient} <= {remainder, quotient, 1'b0};
            end

            // Update counter and check completion
            if (cnt == 7) begin
                // Final correction and sign handling
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