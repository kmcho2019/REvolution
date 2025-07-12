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
reg [15:0] sr;  // shift register
reg [3:0] cnt;  // counter
reg start_cnt;
reg [7:0] neg_divisor;
reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [7:0] temp_result;
reg [7:0] remainder;

assign res_valid = (cnt == 8) && start_cnt;

always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 8'b0;
        divisor_reg <= 8'b0;
        sr <= 16'b0;
        cnt <= 4'b0;
        start_cnt <= 1'b0;
        neg_divisor <= 8'b0;
        abs_dividend <= 8'b0;
        abs_divisor <= 8'b0;
        temp_result <= 8'b0;
        remainder <= 8'b0;
    end else if (opn_valid && !res_valid) begin
        // save inputs
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        
        // initialize shift register and counter
        abs_dividend <= (sign == 1'b1) ? (dividend[7] ? (~dividend + 1) : dividend) : dividend;
        abs_divisor <= (sign == 1'b1) ? (divisor[7] ? (~divisor + 1) : divisor) : divisor;
        sr <= {1'b0, abs_dividend};
        neg_divisor <= (~abs_divisor + 1);
        cnt <= 1;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            // division complete, update result and clear counter
            remainder <= sr[15:8];
            temp_result <= sr[7:0];
            if (sign == 1'b1 && (dividend_reg[7] ^ divisor_reg[7])) begin
                remainder <= ~remainder + 1;
                temp_result <= ~temp_result + 1;
            end
            start_cnt <= 1'b0;
            cnt <= 4'b0;
        end else begin
            // perform subtraction and update shift register
            if (sr[15:8] >= abs_divisor) begin
                sr <= {sr[15:8] - abs_divisor, 1'b1, sr[7:1]};
            end else begin
                sr <= {sr[15:8], 1'b0, sr[7:1]};
            end
            cnt <= cnt + 1;
        end
    end
    
    if (!rst && !start_cnt && res_valid) begin
        // output result
        result <= {remainder, temp_result};
    end
end

endmodule