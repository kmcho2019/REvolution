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
reg [8:0] SR;  // [8:1] remainder, [0] quotient bit
reg [7:0] NEG_DIVISOR;
reg [2:0] cnt;
reg computing;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        cnt <= 3'd0;
        computing <= 1'b0;
        SR <= 9'd0;
        result <= 16'd0;
    end else begin
        if (opn_valid && !computing && !res_valid) begin
            // Capture inputs and initialize
            dividend_sign <= sign & dividend[7];
            divisor_sign <= sign & divisor[7];
            
            abs_dividend <= (sign & dividend[7]) ? -dividend : dividend;
            abs_divisor <= (sign & divisor[7]) ? -divisor : divisor;
            NEG_DIVISOR <= -((sign & divisor[7]) ? -divisor : divisor);
            
            SR <= {8'd0, abs_dividend} << 1;
            cnt <= 3'd0;
            computing <= 1'b1;
            res_valid <= 1'b0;
        end
        
        if (computing) begin
            // Division step
            if (cnt == 3'd7) begin
                // Final processing
                computing <= 1'b0;
                
                // Sign correction
                if (sign) begin
                    result[7:0] <= (dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0];
                    result[15:8] <= dividend_sign ? -(SR[8] ? SR[7:0] + abs_divisor : SR[7:0]) 
                                         : (SR[8] ? SR[7:0] + abs_divisor : SR[7:0]);
                end else begin
                    result <= {(SR[8] ? SR[7:0] + abs_divisor : SR[7:0]), SR[7:0]};
                end
                
                res_valid <= 1'b1;
            end else begin
                // Compute next step
                SR <= (SR[8] ? {SR[7:0], 1'b0} + {1'b0, NEG_DIVISOR} : {SR[7:0], 1'b0}) << 1 | 1'b0;
                cnt <= cnt + 1;
            end
        end
        
        // Clear valid when new operation starts
        if (opn_valid && res_valid) begin
            res_valid <= 1'b0;
        end
    end
end

endmodule