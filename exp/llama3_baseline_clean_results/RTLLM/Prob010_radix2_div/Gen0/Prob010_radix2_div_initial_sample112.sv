module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [7:0] abs_dividend;
reg [7:0] neg_divisor;
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] sr;
reg [3:0] cnt;
reg start_cnt;
reg res_valid_reg;

assign res_valid = res_valid_reg;

always @(*) begin
    if (sign) begin
        abs_dividend = ~dividend + 1;
        neg_divisor = ~divisor + 1;
    end else begin
        abs_dividend = dividend;
        neg_divisor = ~divisor + 1;
    end
end

always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 8'b0;
        divisor_reg <= 8'b0;
        sr <= 8'b0;
        cnt <= 4'b0;
        start_cnt <= 1'b0;
        res_valid_reg <= 1'b0;
    end else if (opn_valid && ~res_valid_reg) begin
        dividend_reg <= abs_dividend;
        divisor_reg <= divisor;
        sr <= {1'b0, abs_dividend};
        cnt <= 4'b1;
        start_cnt <= 1'b1;
        res_valid_reg <= 1'b0;
    end else if (start_cnt) begin
        if (cnt == 8'b1000) begin
            cnt <= 4'b0;
            start_cnt <= 1'b0;
            res_valid_reg <= 1'b1;
            sr <= {sr[7:0], 1'b0};
        end else begin
            reg [8:0] temp;
            temp = {1'b0, sr[7:0]} - neg_divisor;
            if (temp[8]) begin
                sr <= {1'b1, sr[7:0]} << 1;
            end else begin
                sr <= {1'b0, sr[7:0]} << 1;
            end
            cnt <= cnt + 1'b1;
        end
    end else if (res_valid_reg) begin
        res_valid_reg <= 1'b0;
    end
end

always @(*) begin
    if (res_valid_reg) begin
        result = {sr[7:0], sr[7:0]};
    end else begin
        result = 16'b0;
    end
end

endmodule