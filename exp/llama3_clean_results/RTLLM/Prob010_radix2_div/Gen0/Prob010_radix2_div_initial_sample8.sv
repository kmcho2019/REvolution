module radix2_div(
    input  wire        clk,
    input  wire        rst,
    input  wire        sign,
    input  wire [7:0]  dividend,
    input  wire [7:0]  divisor,
    input  wire        opn_valid,
    output wire        res_valid,
    output wire [15:0] result
);

reg [7:0]  abs_dividend;
reg [7:0]  abs_divisor;
reg [7:0]  neg_divisor;
reg [3:0]  cnt;
reg        start_cnt;
reg [15:0] sr;

wire [7:0] sub_result;
wire       carry_out;

assign sub_result = sr[7:0] - abs_divisor;
assign carry_out  = (sr[7:0] < abs_divisor)? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (rst) begin
        abs_dividend <= 8'd0;
        abs_divisor  <= 8'd0;
        neg_divisor  <= 8'd0;
        cnt          <= 4'd0;
        start_cnt    <= 1'b0;
        sr           <= 16'd0;
        res_valid    <= 1'b0;
    end else if (opn_valid &&!res_valid) begin
        if (sign) begin
            abs_dividend <= (dividend[7] == 1'b0)? dividend : (~dividend + 1'b1);
            abs_divisor  <= (divisor[7] == 1'b0)? divisor : (~divisor + 1'b1);
        end else begin
            abs_dividend <= dividend;
            abs_divisor  <= divisor;
        end
        neg_divisor  <= (~abs_divisor + 1'b1);
        sr           <= {1'b0, abs_dividend};
        cnt          <= 4'd1;
        start_cnt    <= 1'b1;
    end else if (start_cnt) begin
        if (cnt == 4'd8) begin
            start_cnt    <= 1'b0;
            res_valid    <= 1'b1;
            sr           <= {sub_result, cnt};
        end else begin
            cnt          <= cnt + 1'b1;
            if (carry_out) begin
                sr       <= {1'b1, sr[14:1]};
            end else begin
                sr       <= {1'b0, sr[14:1]};
            end
        end
    end else if (res_valid &&!opn_valid) begin
        res_valid    <= 1'b0;
    end
end

assign result = sr;

endmodule