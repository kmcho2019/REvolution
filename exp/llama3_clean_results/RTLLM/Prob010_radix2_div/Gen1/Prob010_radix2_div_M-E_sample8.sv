module radix2_div(
    input  wire        clk,
    input  wire        rst,
    input  wire        sign,
    input  wire [7:0]  dividend,
    input  wire [7:0]  divisor,
    input  wire        opn_valid,
    output reg         res_valid,
    output reg [15:0]  result
);

reg [7:0]  abs_dividend;
reg [7:0]  abs_divisor;
reg [15:0] sr1;
reg [7:0]  sr2;
reg [3:0]  cnt;
reg         start_cnt;
reg         neg_result;

wire [7:0] sub_result;
wire        carry_out;

assign sub_result = sr1[7:0] - sr2;
assign carry_out  = (sr1[7:0] < sr2)? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (rst) begin
        abs_dividend <= 8'd0;
        abs_divisor  <= 8'd0;
        sr1          <= 16'd0;
        sr2          <= 8'd0;
        cnt          <= 4'd0;
        start_cnt    <= 1'b0;
        res_valid    <= 1'b0;
        neg_result   <= 1'b0;
    end else if (opn_valid && !res_valid) begin
        if (sign) begin
            abs_dividend <= (dividend[7] == 1'b0)? dividend : (~dividend + 1'b1);
            abs_divisor  <= (divisor[7] == 1'b0)? divisor : (~divisor + 1'b1);
            neg_result   <= (dividend[7] ^ divisor[7]);
        end else begin
            abs_dividend <= dividend;
            abs_divisor  <= divisor;
        end
        sr1          <= {1'b0, abs_dividend};
        sr2          <= abs_divisor;
        cnt          <= 4'd1;
        start_cnt    <= 1'b1;
    end else if (start_cnt) begin
        if (cnt == 4'd8) begin
            start_cnt    <= 1'b0;
            res_valid    <= 1'b1;
            if (sign && neg_result) begin
                result    <= {~sr1[15:8] + 1'b1, sr1[7:0]};
            end else begin
                result    <= sr1;
            end
        end else begin
            cnt          <= cnt + 1'b1;
            if (carry_out) begin
                sr1        <= {1'b1, sr1[14:1]};
            end else begin
                sr1        <= {1'b0, sr1[14:1]};
            end
        end
    end else if (res_valid && !opn_valid) begin
        res_valid    <= 1'b0;
    end
end

endmodule