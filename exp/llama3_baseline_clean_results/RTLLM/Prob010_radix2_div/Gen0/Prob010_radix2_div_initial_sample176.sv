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
reg [7:0] neg_divisor;
reg [15:0] sr;
reg [2:0] cnt;
reg start_cnt;
reg [15:0] temp_result;

assign result = temp_result;

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        start_cnt <= 0;
        cnt <= 0;
        sr <= 0;
        neg_divisor <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
    end else if (opn_valid &&!res_valid) begin
        // Save inputs
        dividend_reg <= sign? {{7{dividend[7]}}, dividend[7:0]} : {8'd0, dividend[7:0]};
        divisor_reg <= sign? {{7{divisor[7]}}, divisor[7:0]} : {8'd0, divisor[7:0]};
        
        // Initialize SR with absolute value of dividend shifted left by one bit
        sr <= {1'b0, dividend_reg[7:0]};
        
        // Set NEG_DIVISOR to the negated absolute value of the divisor
        neg_divisor <= ~divisor_reg[7:0] + 1;
        
        // Set counter cnt to 1 and start_cnt to 1
        cnt <= 1;
        start_cnt <= 1;
        
        res_valid <= 0;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            // Division is complete
            start_cnt <= 0;
            cnt <= 0;
            temp_result <= {sr[15:8], sr[7:0]};
            res_valid <= 1;
        end else begin
            // Compute subtraction of NEG_DIVISOR
            reg [16:0] sub_result;
            reg carry_out;
            sub_result <= sr[15:0] - {8'd0, neg_divisor};
            carry_out <= sub_result[16];
            
            // Update SR by shifting left and inserting the carry-out
            sr <= {carry_out, sr[15:1]};
            
            // Increment counter
            cnt <= cnt + 1;
        end
    end else if (res_valid) begin
        // Reset res_valid when result is consumed
        res_valid <= 0;
    end
end

endmodule