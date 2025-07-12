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

reg [7:0] SR;
reg [7:0] NEG_DIVISOR;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] dividend_abs;
reg [7:0] divisor_abs;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        start_cnt <= 0;
        cnt <= 0;
    end else if (opn_valid && !res_valid) begin
        dividend_abs <= (sign && dividend[7]) ? ~dividend + 1 : dividend;
        divisor_abs <= (sign && divisor[7]) ? ~divisor + 1 : divisor;
        SR <= {1'b0, dividend_abs};
        NEG_DIVISOR <= ~divisor_abs + 1;
        start_cnt <= 1;
        cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            start_cnt <= 0;
            cnt <= 0;
            result <= {SR[15:8], SR[7:0]};
            res_valid <= 1;
        end else begin
            reg [8:0] sub;
            sub <= {SR[15:0], 1'b0} - {NEG_DIVISOR, 1'b0};
            SR <= {sub[8], SR[15:1]};
            cnt <= cnt + 1;
        end
    end
end

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
    end else if (res_valid && !opn_valid) begin
        res_valid <= 0;
    end
end

endmodule