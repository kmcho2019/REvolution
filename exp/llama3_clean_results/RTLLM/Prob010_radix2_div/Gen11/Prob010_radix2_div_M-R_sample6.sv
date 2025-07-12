module radix2_div(
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
reg [7:0] neg_divisor;  
reg [15:0] shift_reg;  
reg [3:0] cnt;
reg start_cnt;
reg [15:0] next_shift_reg;

assign neg_divisor = ~divisor_reg + 1;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        shift_reg <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else begin
        if (opn_valid &&!res_valid) begin
            dividend_reg <= sign? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
            divisor_reg <= sign? {{7{divisor[7]}}, divisor[7:0]} : divisor;
            shift_reg <= {8'b0, dividend_reg};  
            cnt <= 1;
            start_cnt <= 1;
            res_valid <= 0;
        end

        if (start_cnt) begin
            if (cnt == 8) begin
                result <= {shift_reg[15:8], shift_reg[7:0]};  
                res_valid <= 1;
                cnt <= 0;
                start_cnt <= 0;
            end else begin
                if (shift_reg[15:8] >= divisor_reg) begin
                    next_shift_reg <= {shift_reg[15:8] - divisor_reg, 1'b1, shift_reg[7:1]};  
                end else begin
                    next_shift_reg <= {shift_reg[15:8], 1'b0, shift_reg[7:1]};  
                end
                shift_reg <= next_shift_reg;
                cnt <= cnt + 1;
            end
        end

        if (!opn_valid && res_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule