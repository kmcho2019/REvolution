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
reg [15:0] temp_result;

always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        neg_divisor <= 0;
        shift_reg <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        dividend_reg <= sign ? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
        divisor_reg <= sign ? {{7{divisor[7]}}, divisor[7:0]} : divisor;
        neg_divisor <= ~divisor_reg + 1;
        shift_reg <= {8'b0, dividend_reg};
        start_cnt <= 1;
        cnt <= 0;
        res_valid <= 0;
    end
end

always @(posedge clk) begin
    if (rst || (!opn_valid && res_valid)) begin
        res_valid <= 0;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            temp_result <= {shift_reg[15:8], shift_reg[7:0]};
            start_cnt <= 0;
            cnt <= 0;
        end else begin
            if (shift_reg[15:8] >= divisor_reg) begin
                shift_reg <= {shift_reg[15:8] - divisor_reg, 1'b1, shift_reg[7:1]};
            end else begin
                shift_reg <= {shift_reg[15:8], 1'b0, shift_reg[7:1]};
            end
            cnt <= cnt + 1;
        end
    end
end

always @(posedge clk) begin
    if (rst) begin
        result <= 0;
        res_valid <= 0;
    end else if (temp_result != 0) begin
        result <= temp_result;
        res_valid <= 1;
    end else begin
        res_valid <= 0;
    end
end

endmodule