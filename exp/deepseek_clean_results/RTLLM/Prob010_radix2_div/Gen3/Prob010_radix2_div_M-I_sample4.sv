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
reg [8:0] SR;  // Optimized: [8:1] remainder, [0] quotient bit
reg [7:0] NEG_DIVISOR;
reg [2:0] cnt;  // Reduced to 3 bits
reg start_cnt;
reg div_by_zero;

wire [8:0] sub_result = {SR[8:1], 1'b0} + {1'b0, NEG_DIVISOR};
wire carry_out = sub_result[8];
wire [7:0] final_quotient;
wire [7:0] final_remainder;

// Early division by zero detection
always @(*) begin
    div_by_zero = (abs_divisor == 8'd0);
end

// Final result assembly
assign final_remainder = (div_by_zero) ? 8'hFF : 
                        (SR[8] ? SR[7:0] + abs_divisor : SR[7:0]);
assign final_quotient = (div_by_zero) ? 8'hFF : SR[8:0];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        cnt <= 3'd0;
        start_cnt <= 1'b0;
        SR <= 9'd0;
        result <= 16'd0;
    end else begin
        // Clock gating: only update when needed
        if (opn_valid || start_cnt) begin
            if (opn_valid && !res_valid && !start_cnt) begin
                // Input capture and initialization
                dividend_sign <= sign & dividend[7];
                divisor_sign <= sign & divisor[7];
                
                abs_dividend <= (sign & dividend[7]) ? -dividend : dividend;
                abs_divisor <= (sign & divisor[7]) ? -divisor : divisor;
                
                NEG_DIVISOR <= -((sign & divisor[7]) ? -divisor : divisor);
                SR <= {8'd0, (sign & dividend[7]) ? -dividend : dividend} << 1;
                cnt <= 3'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end
            
            if (start_cnt) begin
                if (cnt == 3'd0) begin  // cnt wraps after 7
                    // Final processing
                    start_cnt <= 1'b0;
                    
                    // Sign correction
                    if (sign) begin
                        result[7:0] <= (dividend_sign ^ divisor_sign) ? -final_quotient : final_quotient;
                        result[15:8] <= dividend_sign ? -final_remainder : final_remainder;
                    end else begin
                        result <= {final_remainder, final_quotient};
                    end
                    
                    res_valid <= 1'b1;
                end else begin
                    // Division step
                    cnt <= cnt + 1;
                    SR <= carry_out ? {sub_result[7:0], 1'b1} : {SR[7:0], 1'b0};
                end
            end
            
            // Clear valid when result is consumed
            if (res_valid && opn_valid) begin
                res_valid <= 1'b0;
            end
        end
    end
end

endmodule