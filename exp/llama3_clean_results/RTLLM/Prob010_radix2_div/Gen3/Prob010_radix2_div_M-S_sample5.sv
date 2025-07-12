module radix2_div(
    input               clk,
    input               rst,
    input               sign,
    input      [7:0]     dividend,
    input      [7:0]     divisor,
    input               opn_valid,
    output              res_valid,
    output     [15:0]    result
);

reg [15:0] sr; // shift register
reg [7:0]  abs_divisor; // absolute value of divisor
reg [7:0]  neg_divisor; // negated absolute value of divisor
reg [2:0]  cnt; // counter
reg        start_cnt; // flag to start division
reg        res_valid_int; // internal res_valid signal

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        abs_divisor <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid_int <= 0;
    end else if (opn_valid &&!res_valid_int) begin
        abs_divisor <= sign? (~divisor + 1) : divisor;
        neg_divisor <= ~abs_divisor + 1;
        sr <= {1'b0, sign? (~dividend + 1) : dividend};
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            cnt <= 0;
            start_cnt <= 0;
            res_valid_int <= 1;
        end else begin
            reg [8:0] tmp;
            tmp <= {1'b0, sr[15:8]} - abs_divisor;
            sr <= {tmp[8], tmp[7:0], sr[0]};
            cnt <= cnt + 1;
        end
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
    end else if (res_valid_int) begin
        res_valid <= 1;
    end else if (res_valid &&!opn_valid) begin
        res_valid <= 0;
    end
end

assign result = sr;

endmodule