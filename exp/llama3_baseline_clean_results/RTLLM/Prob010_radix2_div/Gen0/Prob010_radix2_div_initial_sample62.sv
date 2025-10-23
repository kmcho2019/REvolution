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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [15:0] sr; // shift register
reg [7:0] neg_divisor;
reg [3:0] cnt;
reg start_cnt;
reg [15:0] result_reg;

wire [7:0] abs_dividend;
wire [7:0] abs_divisor;

assign abs_dividend = (sign) ? {~dividend[7] & 8'b1, dividend[6:0]} + 1'b1 : dividend;
assign abs_divisor = (sign) ? {~divisor[7] & 8'b1, divisor[6:0]} + 1'b1 : divisor;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        sr <= 16'd0;
        neg_divisor <= 8'd0;
        cnt <= 4'd0;
        start_cnt <= 1'b0;
        result_reg <= 16'd0;
        res_valid <= 1'b0;
    end else if (opn_valid && !res_valid) begin
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        sr <= {1'b0, abs_dividend};
        neg_divisor <= ~abs_divisor + 1'b1;
        cnt <= 4'd1;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            start_cnt <= 1'b0;
            cnt <= 4'd0;
            if (sign) begin
                if ((dividend_reg[7] ^ divisor_reg[7])) begin
                    result_reg <= {sr[15:8], ~sr[7:0] + 1'b1};
                end else begin
                    result_reg <= sr;
                end
            end else begin
                result_reg <= sr;
            end
            res_valid <= 1'b1;
        end else begin
            wire [8:0] sub_result;
            assign sub_result = {1'b0, sr[7:0]} - neg_divisor;
            if (sub_result[8]) begin
                sr <= {1'b1, sr[7:0]};
            end else begin
                sr <= {1'b0, sr[7:0]} + sub_result;
            end
            cnt <= cnt + 1;
        end
    end else if (res_valid) begin
        res_valid <= 1'b0;
    end
end

assign result = result_reg;

endmodule