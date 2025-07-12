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
reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [7:0] NEG_DIVISOR;
reg [7:0] SR;
reg [2:0] cnt;
reg start_cnt;
reg [15:0] result_reg;
reg res_valid_reg;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        cnt <= 0;
        start_cnt <= 0;
        res_valid_reg <= 0;
        result_reg <= 0;
        SR <= 0;
        NEG_DIVISOR <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        abs_dividend <= 0;
        abs_divisor <= 0;
    end else if(opn_valid && !res_valid_reg) begin
        // Initialize the registers
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        abs_dividend <= (sign) ? ({8{dividend[7]}} ^ dividend) + 1 : dividend;
        abs_divisor <= (sign) ? ({8{divisor[7]}} ^ divisor) + 1 : divisor;
        NEG_DIVISOR <= ({8{abs_divisor[7]}} ^ abs_divisor) + 1;
        SR <= {1'b0, abs_dividend};
        cnt <= 1;
        start_cnt <= 1;
        res_valid_reg <= 0;
    end else if(start_cnt) begin
        if(cnt == 8) begin
            // Division is complete
            start_cnt <= 0;
            cnt <= 0;
            result_reg <= {SR[8:1], SR[0]};
            res_valid_reg <= 1;
        end else begin
            // Perform subtraction and update SR
            reg [8:0] temp;
            temp <= SR - NEG_DIVISOR;
            if(temp[8]) begin
                // No borrow
                SR <= {1'b0, SR[7:0]} << 1;
            end else begin
                // Borrow
                SR <= {temp[7:0], 1'b1} << 1;
            end
            cnt <= cnt + 1;
        end
    end
end

assign res_valid = res_valid_reg;
assign result = result_reg;

endmodule