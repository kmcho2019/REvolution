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
reg [3:0] cnt;
reg start_cnt;
reg [16:0] SR;  // Shift register (1 extra bit for carry)
reg [7:0] NEG_DIVISOR;
wire [8:0] sub_result;
wire carry_out;
reg [7:0] final_quotient;
reg [7:0] final_remainder;

// Subtraction result and carry
assign sub_result = SR[15:8] + NEG_DIVISOR;
assign carry_out = ~sub_result[8];  // Carry out is inverted (since we added negative)

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        cnt <= 0;
        start_cnt <= 0;
        SR <= 0;
        result <= 0;
    end else begin
        // Operation start
        if (opn_valid && !res_valid && !start_cnt) begin
            sign_reg <= sign;
            
            // Handle signed conversion
            if (sign) begin
                dividend_reg <= dividend[7] ? -dividend : dividend;
                divisor_reg <= divisor[7] ? -divisor : divisor;
            end else begin
                dividend_reg <= dividend;
                divisor_reg <= divisor;
            end
            
            NEG_DIVISOR <= -(divisor_reg);
            SR <= {9'b0, dividend_reg, 1'b0};  // Initialize SR with dividend shifted left by 1
            cnt <= 0;
            start_cnt <= 1;
            res_valid <= 0;
        end
        
        // Division process
        if (start_cnt) begin
            if (cnt == 8) begin
                // Division complete
                start_cnt <= 0;
                cnt <= 0;
                
                // Extract final results
                final_remainder <= SR[15:8];
                final_quotient <= SR[7:0];
                
                // Handle sign correction
                if (sign_reg) begin
                    if (dividend[7] ^ divisor[7]) begin
                        final_quotient <= -final_quotient;
                    end
                    if (dividend[7]) begin
                        final_remainder <= -final_remainder;
                    end
                end
                
                // Combine results
                result <= {final_remainder, final_quotient};
                res_valid <= 1;
            end else begin
                // Perform one division step
                cnt <= cnt + 1;
                
                if (carry_out) begin
                    SR <= {sub_result[7:0], SR[7:0], 1'b1};
                end else begin
                    SR <= {SR[15:0], 1'b0};
                end
            end
        end
        
        // Clear valid when result is consumed
        if (res_valid && opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule