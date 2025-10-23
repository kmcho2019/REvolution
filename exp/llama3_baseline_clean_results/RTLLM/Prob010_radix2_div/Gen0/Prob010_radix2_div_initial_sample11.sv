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
reg [7:0] neg_divisor_reg;
reg [15:0] sr;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] quotient;
reg [7:0] remainder;

assign result = {remainder, quotient};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        neg_divisor_reg <= 0;
        sr <= 0;
        cnt <= 0;
        start_cnt <= 0;
        quotient <= 0;
        remainder <= 0;
    end else if (opn_valid &&!res_valid) begin
        // Save inputs
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        neg_divisor_reg <= ~divisor + 1;
        
        // Initialize shift register
        sr <= {dividend_reg[7], dividend_reg};
        
        // Initialize counter
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete
            start_cnt <= 0;
            res_valid <= 1;
            quotient <= sr[7:0];
            remainder <= sr[15:8];
        end else begin
            // Perform subtraction
            reg [8:0] sub_result;
            sub_result <= sr[15:8] - divisor_reg;
            
            // Update shift register
            if (sub_result[8]) begin
                // No borrow
                sr <= {1'b0, sr[15:1], 1'b0};
            end else begin
                // Borrow
                sr <= {1'b1, sr[15:1], 1'b1};
            end
            
            // Increment counter
            cnt <= cnt + 1;
        end
    end else if (res_valid &&!opn_valid) begin
        res_valid <= 0;
    end
end

endmodule