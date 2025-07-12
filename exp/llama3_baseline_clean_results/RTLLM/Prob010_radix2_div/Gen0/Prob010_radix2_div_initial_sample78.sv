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
reg [7:0] sr; // shift register
reg [7:0] neg_divisor; // negated divisor
reg [2:0] cnt; // counter for 8 iterations
reg start_cnt; // flag to start division
reg [15:0] result_reg; // result register
reg res_valid_reg; // result validity register
reg carry_out; // carry-out from subtraction

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt <= 0;
        start_cnt <= 0;
        res_valid_reg <= 0;
        result_reg <= 0;
    end else if (opn_valid &&!res_valid_reg) begin
        // Save inputs
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        
        // Initialize shift register and negated divisor
        sr <= {1'b0, dividend_reg[7:0]};
        neg_divisor <= ~divisor_reg + 1;
        
        // Initialize counter and start flag
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        // Division process
        if (cnt == 8) begin
            // Division complete
            cnt <= 0;
            start_cnt <= 0;
            result_reg <= {sr[15:8], sr[7:0]};
            res_valid_reg <= 1;
        end else begin
            // Subtract divisor from shift register
            {carry_out, sr} <= sr - {8'b0, neg_divisor};
            
            // Update shift register based on carry-out
            if (carry_out) begin
                sr <= {1'b1, sr[15:1]};
            end else begin
                sr <= {1'b0, sr[15:1]};
            end
            
            // Increment counter
            cnt <= cnt + 1;
        end
    end else if (res_valid_reg &&!opn_valid) begin
        // Reset result validity
        res_valid_reg <= 0;
    end
end

assign res_valid = res_valid_reg;
assign result = result_reg;

endmodule