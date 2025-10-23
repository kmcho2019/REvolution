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

    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg dividend_sign;
    reg divisor_sign;
    reg result_sign;
    
    reg [15:0] SR;          // Shift register (remainder | quotient)
    reg [7:0] NEG_DIVISOR;  // Negative of absolute divisor
    reg [3:0] cnt;          // Counter (0-8)
    reg start_cnt;          // Start counting flag
    
    wire [8:0] sub_result;  // 9-bit subtraction result (1 bit for carry)
    wire carry_out;
    
    // Absolute value and sign calculation
    always @(*) begin
        if (sign) begin
            abs_dividend = dividend[7] ? -dividend : dividend;
            abs_divisor = divisor[7] ? -divisor : divisor;
            dividend_sign = dividend[7];
            divisor_sign = divisor[7];
            result_sign = dividend_sign ^ divisor_sign;
        end else begin
            abs_dividend = dividend;
            abs_divisor = divisor;
            dividend_sign = 0;
            divisor_sign = 0;
            result_sign = 0;
        end
    end
    
    // Subtraction result (SR[15:8] + NEG_DIVISOR)
    assign sub_result = {1'b0, SR[15:8]} + {1'b0, NEG_DIVISOR};
    assign carry_out = ~sub_result[8];  // Carry out is inverted for subtraction
    
    always @(posedge clk) begin
        if (rst) begin
            SR <= 16'b0;
            NEG_DIVISOR <= 8'b0;
            cnt <= 4'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'b0;
        end else begin
            if (opn_valid && !res_valid && !start_cnt) begin
                // Initialize operation
                SR <= {8'b0, abs_dividend} << 1;
                NEG_DIVISOR <= -abs_divisor;
                cnt <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                if (cnt[3]) begin  // cnt == 8 (1000)
                    // Finalize operation
                    start_cnt <= 1'b0;
                    cnt <= 4'b0;
                    
                    // Correct remainder (undo final shift)
                    SR[15:8] <= SR[15:8] >> 1;
                    
                    // Apply sign correction if signed operation
                    if (sign) begin
                        // Quotient sign correction
                        SR[7:0] <= result_sign ? -SR[7:0] : SR[7:0];
                        // Remainder sign correction (same as dividend)
                        SR[15:8] <= dividend_sign ? -SR[15:8] : SR[15:8];
                    end
                    
                    res_valid <= 1'b1;
                    result <= SR;
                end else begin
                    // Perform division step
                    cnt <= cnt + 1;
                    
                    if (carry_out) begin
                        // Update SR with subtraction result and set LSB
                        SR <= {sub_result[7:0], SR[7:1], 1'b1};
                    end else begin
                        // Just shift left
                        SR <= {SR[14:0], 1'b0};
                    end
                end
            end
            
            // Clear res_valid when result is read
            if (res_valid && opn_valid) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule