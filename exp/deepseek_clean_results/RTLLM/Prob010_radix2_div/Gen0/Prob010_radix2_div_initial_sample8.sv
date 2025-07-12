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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg sign_reg;
reg [15:0] SR;       // Shift register (remainder | quotient)
reg [7:0] NEG_DIVISOR;
reg [3:0] cnt;
reg start_cnt;
wire [8:0] sub_result;
wire carry_out;
reg dividend_sign;
reg divisor_sign;

// Subtraction result
assign sub_result = SR[15:8] + NEG_DIVISOR;
assign carry_out = ~sub_result[8];  // Carry out is inverted because we added negative

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 16'b0;
        cnt <= 0;
        start_cnt <= 0;
        SR <= 16'b0;
    end else begin
        // Operation start
        if (opn_valid && !res_valid && !start_cnt) begin
            sign_reg <= sign;
            
            // Store absolute values and signs
            if (sign && dividend[7]) begin
                dividend_reg <= ~dividend + 1;
                dividend_sign <= 1;
            end else begin
                dividend_reg <= dividend;
                dividend_sign <= 0;
            end
            
            if (sign && divisor[7]) begin
                divisor_reg <= ~divisor + 1;
                divisor_sign <= 1;
            end else begin
                divisor_reg <= divisor;
                divisor_sign <= 0;
            end
            
            // Initialize shift register (dividend << 1)
            SR <= {8'b0, dividend_reg, 7'b0};
            NEG_DIVISOR <= ~divisor_reg + 1;
            cnt <= 1;
            start_cnt <= 1;
            res_valid <= 0;
        end
        
        // Division process
        if (start_cnt) begin
            if (cnt[3]) begin  // cnt == 8
                // Final result processing
                start_cnt <= 0;
                cnt <= 0;
                
                // Handle negative results
                if (sign_reg) begin
                    // Quotient sign: dividend_sign XOR divisor_sign
                    if (dividend_sign ^ divisor_sign) begin
                        SR[7:0] <= ~SR[7:0] + 1;
                    end
                    
                    // Remainder sign: dividend_sign
                    if (dividend_sign) begin
                        SR[15:8] <= ~SR[15:8] + 1;
                    end
                end
                
                result <= {SR[15:8], SR[7:0]};
                res_valid <= 1;
            end else begin
                // Perform subtraction and shift
                if (carry_out) begin
                    SR <= {sub_result[7:0], SR[7:0], 1'b1};
                end else begin
                    SR <= {SR[15:8], SR[7:0], 1'b0};
                end
                
                cnt <= cnt + 1;
            end
        end
        
        // Clear valid when result is consumed
        if (res_valid && opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule