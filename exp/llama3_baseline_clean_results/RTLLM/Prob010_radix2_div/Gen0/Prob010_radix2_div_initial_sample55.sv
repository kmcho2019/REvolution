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

reg [7:0] sr;  // Shift register
reg [7:0] neg_divisor;  // Negated absolute value of divisor
reg [2:0] cnt;  // Counter
reg start_cnt;  // Start counter flag
reg [7:0] dividend_reg;  // Registered dividend
reg [7:0] divisor_reg;  // Registered divisor

// Initialize shift register, NEG_DIVISOR, and counter
always @(posedge clk) begin
    if (rst) begin
        sr <= 8'b0;
        neg_divisor <= 8'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
    end else if (opn_valid &&!res_valid) begin
        // Save inputs
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        
        // Initialize shift register with absolute value of dividend shifted left by one bit
        if (sign) begin
            // Signed operation
            sr <= {1'b0, (dividend_reg[7] == 1'b1)? (~dividend_reg + 1'b1) : dividend_reg};
        end else begin
            // Unsigned operation
            sr <= {1'b0, dividend_reg};
        end
        
        // Set NEG_DIVISOR to negated absolute value of divisor
        if (sign && divisor_reg[7] == 1'b1) begin
            neg_divisor <= ~(divisor_reg + 1'b1);
        end else begin
            neg_divisor <= ~divisor_reg;
        end
        
        // Set counter and start flag
        cnt <= 3'b1;
        start_cnt <= 1'b1;
        res_valid <= 1'b0;
    end else if (start_cnt) begin
        // Division process
        if (cnt == 8'b1000) begin
            // Division complete
            cnt <= 3'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b1;
            result <= {sr[7:0], sr[7:0]};
        end else begin
            // Update counter and shift register
            cnt <= cnt + 1'b1;
            
            // Compute subtraction of NEG_DIVISOR
            reg [8:0] sub_result;
            reg carry_out;
            sub_result = {1'b0, sr[7:0]} - {1'b0, neg_divisor};
            carry_out = sub_result[8];
            
            // Update shift register based on carry-out
            if (carry_out) begin
                sr <= {1'b1, sr[7:1]};
            end else begin
                sr <= {1'b0, sr[7:1]};
            end
        end
    end else if (rst) begin
        // Reset result validity
        res_valid <= 1'b0;
    end
end

endmodule