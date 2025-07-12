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
reg [15:0] sr; // shift register
reg [7:0] neg_divisor; // negated absolute value of divisor
reg [2:0] cnt; // counter
reg start_cnt; // flag to start division
reg [15:0] temp_result; // temporary result
reg result_valid; // flag to indicate result validity

assign res_valid = result_valid;
assign result = temp_result;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 8'b0;
        divisor_reg <= 8'b0;
        sr <= 16'b0;
        neg_divisor <= 8'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
        result_valid <= 1'b0;
    end else if (opn_valid &&!result_valid) begin
        // save inputs
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        
        // initialize shift register
        if (sign) begin
            // signed division
            if (dividend[7]) begin
                sr <= {1'b0, ~dividend} + 1;
            end else begin
                sr <= {1'b0, dividend};
            end
        end else begin
            // unsigned division
            sr <= {1'b0, dividend};
        end
        
        // set negated absolute value of divisor
        if (sign && divisor[7]) begin
            neg_divisor <= ~divisor + 1;
        end else begin
            neg_divisor <= divisor;
        end
        
        // set counter and start flag
        cnt <= 1;
        start_cnt <= 1'b1;
        result_valid <= 1'b0;
    end else if (start_cnt) begin
        // division process
        if (cnt == 8) begin
            // division complete
            start_cnt <= 1'b0;
            cnt <= 3'b0;
            result_valid <= 1'b1;
            temp_result <= sr;
        end else begin
            // compute subtraction
            reg [8:0] sub_result;
            reg carry_out;
            sub_result <= sr[15:8] - neg_divisor;
            carry_out <= sub_result[8];
            
            // update shift register
            sr <= {carry_out, sr[15:1]};
            
            // increment counter
            cnt <= cnt + 1;
        end
    end else if (result_valid &&!opn_valid) begin
        // reset result validity
        result_valid <= 1'b0;
    end
end

endmodule