module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [7:0] sr_remainder;
reg [7:0] sr_quotient;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg res_valid_reg;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        sr_remainder <= 8'd0;
        sr_quotient <= 8'd0;
        neg_divisor <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
        res_valid_reg <= 1'd0;
    end else if(opn_valid && !res_valid_reg) begin
        // Save inputs
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        
        // Initialize shift register SR with the absolute value of the dividend shifted left by one bit
        if(sign) begin
            sr_remainder <= {1'd0, ~dividend_reg[7:0] + 1'd1};
            neg_divisor <= {1'd0, ~divisor_reg[7:0] + 1'd1};
        end else begin
            sr_remainder <= {1'd0, dividend_reg[7:0]};
            neg_divisor <= {1'd0, divisor_reg[7:0]};
        end
        
        // Initialize counter and start_cnt
        cnt <= 3'd1;
        start_cnt <= 1'd1;
        res_valid_reg <= 1'd0;
    end else if(start_cnt) begin
        // Division process
        if(cnt == 3'd8) begin
            // Division complete
            cnt <= 3'd0;
            start_cnt <= 1'd0;
            res_valid_reg <= 1'd1;
            // Update result
            result <= {sr_remainder, sr_quotient};
        end else begin
            // Compute subtraction of NEG_DIVISOR
            reg [8:0] sub_result;
            reg carry_out;
            sub_result = {1'd0, sr_remainder[7:0]} - neg_divisor[7:0];
            carry_out = sub_result[8];
            
            // Update SR based on subtraction result
            if(carry_out) begin
                sr_remainder <= {1'd1, sr_remainder[7:1]};
                sr_quotient <= {sr_quotient[7:1], 1'd0};
            end else begin
                sr_remainder <= {1'd0, sr_remainder[7:1]} + neg_divisor[7:0];
                sr_quotient <= {sr_quotient[7:1], 1'd1};
            end
            
            // Increment counter
            cnt <= cnt + 1'd1;
        end
    end else if(res_valid_reg && !opn_valid) begin
        res_valid_reg <= 1'd0;
    end
end

assign res_valid = res_valid_reg;

endmodule