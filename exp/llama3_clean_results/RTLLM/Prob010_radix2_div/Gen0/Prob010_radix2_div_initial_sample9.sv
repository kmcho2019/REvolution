module radix2_div(
    input         clk,
    input         rst,
    input         sign,
    input  [7:0]  dividend,
    input  [7:0]  divisor,
    input         opn_valid,
    output        res_valid,
    output [15:0] result
);

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg [15:0] sr; // shift register
reg [2:0] cnt; // counter
reg start_cnt;

wire [8:0] sub_result;
wire carry_out;

assign sub_result = {1'b0, sr[7:0]} - {8'b0, neg_divisor};
assign carry_out = sub_result[8];

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 1'b0;
        start_cnt <= 1'b0;
        cnt <= 3'b000;
        sr <= 16'b0;
    end else if (opn_valid &&!res_valid) begin
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        if (sign) begin
            neg_divisor <= ~divisor_reg + 1'b1;
        end else begin
            neg_divisor <= ~divisor_reg + 1'b0;
        end
        sr <= {1'b0, dividend_reg};
        start_cnt <= 1'b1;
        cnt <= 3'b001;
    end else if (start_cnt) begin
        if (cnt == 3'b100) begin
            // division complete
            start_cnt <= 1'b0;
            cnt <= 3'b000;
            result <= {sr[15:8], sr[7:0]};
            res_valid <= 1'b1;
        end else begin
            if (carry_out) begin
                sr <= {1'b1, sr[15:1]};
            end else begin
                sr <= {1'b0, sr[15:1]} + {8'b0, neg_divisor};
            end
            cnt <= cnt + 1'b1;
        end
    end
end

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 1'b0;
    end else if (res_valid &&!opn_valid) begin
        res_valid <= 1'b0;
    end
end

endmodule