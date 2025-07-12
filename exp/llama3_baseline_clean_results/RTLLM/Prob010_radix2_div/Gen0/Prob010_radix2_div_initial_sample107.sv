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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [15:0] sr;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_cnt;
reg [15:0] result_reg;
reg res_valid_reg;

always @(*) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        sr <= 16'd0;
        neg_divisor <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
        result_reg <= 16'd0;
        res_valid_reg <= 1'd0;
    end else if (opn_valid &&!res_valid_reg) begin
        // Save inputs
        dividend_reg <= sign? {{7{dividend[7]}}, dividend[7:0]} : {8'd0, dividend[7:0]};
        divisor_reg <= sign? {{7{divisor[7]}}, divisor[7:0]} : {8'd0, divisor[7:0]};
        
        // Initialize shift register SR with the absolute value of the dividend shifted left by one bit
        sr <= {1'd0, dividend_reg};
        
        // Set NEG_DIVISOR to the negated absolute value of the divisor
        neg_divisor <= ~divisor_reg + 1'd1;
        
        // Set the counter cnt to 1 and start_cnt to 1 to begin the division process
        cnt <= 3'd1;
        start_cnt <= 1'd1;
        
        // Initialize result validity
        res_valid_reg <= 1'd0;
    end else if (start_cnt) begin
        // Division process
        if (cnt == 3'd8) begin
            // Division is complete
            cnt <= 3'd0;
            start_cnt <= 1'd0;
            result_reg <= {sr[15:8], sr[7:0]};
            res_valid_reg <= 1'd1;
        end else begin
            // Compute the subtraction of NEG_DIVISOR
            reg [16:0] sub_result;
            sub_result <= sr - {8'd0, neg_divisor};
            
            // Update SR by shifting left and inserting the carry-out
            if (sub_result[16]) begin
                sr <= {1'd1, sr[15:1]};
            end else begin
                sr <= {1'd0, sr[15:1]} + {8'd0, neg_divisor};
            end
            
            // Increment the counter
            cnt <= cnt + 1'd1;
        end
    end
end

always @(posedge clk) begin
    res_valid <= res_valid_reg;
    result <= result_reg;
end

endmodule