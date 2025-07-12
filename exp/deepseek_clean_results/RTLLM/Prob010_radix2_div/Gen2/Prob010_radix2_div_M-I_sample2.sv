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
reg [15:0] SR;  // [15:8] remainder, [7:0] quotient
reg [7:0] NEG_DIVISOR;
reg [2:0] cnt;  // Reduced from 4 to 3 bits
reg start_cnt;
wire divide_by_zero = (divisor == 8'd0);

// Subtraction result and carry out
wire [8:0] sub_result = {SR[15:8], 1'b0} + {1'b0, NEG_DIVISOR};
wire carry_out = ~sub_result[8];  // Positive result means carry_out=1

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        cnt <= 3'd0;
        start_cnt <= 1'b0;
        SR <= 16'd0;
        result <= 16'd0;
    end else begin
        if (opn_valid && !res_valid) begin
            if (!start_cnt) begin
                // Capture inputs and compute absolute values
                if (sign) begin
                    dividend_sign <= dividend[7];
                    divisor_sign <= divisor[7];
                    abs_dividend <= dividend[7] ? -dividend : dividend;
                    abs_divisor <= divisor[7] ? -divisor : divisor;
                end else begin
                    dividend_sign <= 1'b0;
                    divisor_sign <= 1'b0;
                    abs_dividend <= dividend;
                    abs_divisor <= divisor;
                end
                
                NEG_DIVISOR <= -abs_divisor;
                SR <= {8'd0, abs_dividend} << 1;
                cnt <= 3'd0;
                start_cnt <= !divide_by_zero;
                res_valid <= divide_by_zero;
                result <= divide_by_zero ? 16'hFFFF : 16'd0;
            end
        end
        
        if (start_cnt) begin
            if (&cnt) begin  // cnt == 7 (0-7 counts)
                // Final result processing
                start_cnt <= 1'b0;
                
                // Handle negative remainder
                if (SR[15]) begin
                    SR[15:8] <= SR[15:8] + abs_divisor;
                end
                
                // Apply sign correction
                if (sign) begin
                    // Quotient sign correction
                    SR[7:0] <= (dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0];
                    // Remainder sign correction
                    SR[15:8] <= dividend_sign ? -SR[15:8] : SR[15:8];
                end
                
                result <= SR;
                res_valid <= 1'b1;
            end else begin
                // Division step
                cnt <= cnt + 1;
                
                if (carry_out) begin
                    SR <= {sub_result[7:0], SR[7:1], 1'b1};
                end else begin
                    SR <= {SR[14:0], 1'b0};
                end
            end
        end
        
        // Clear valid when result is consumed
        if (res_valid && opn_valid) begin
            res_valid <= 1'b0;
        end
    end
end

endmodule