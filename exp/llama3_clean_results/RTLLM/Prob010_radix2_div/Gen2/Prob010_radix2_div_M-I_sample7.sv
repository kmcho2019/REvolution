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
reg [15:0] sr;
reg [7:0]  quotient;
reg [7:0]  remainder;
reg [3:0]  cnt;
reg         start_cnt;
reg         neg_result;

always @(posedge clk) begin
    if (rst) begin
        abs_dividend <= 8'd0;
        abs_divisor  <= 8'd0;
        sr          <= 16'd0;
        quotient    <= 8'd0;
        remainder   <= 8'd0;
        cnt         <= 4'd0;
        start_cnt   <= 1'b0;
        res_valid   <= 1'b0;
        neg_result  <= 1'b0;
    end else if (opn_valid && !res_valid) begin
        if (sign) begin
            abs_dividend <= (dividend[7] == 1'b0)? dividend : (~dividend + 1'b1);
            abs_divisor  <= (divisor[7] == 1'b0)? divisor : (~divisor + 1'b1);
            neg_result   <= (dividend[7] ^ divisor[7]);
        end else begin
            abs_dividend <= dividend;
            abs_divisor  <= divisor;
        end
        sr          <= {1'b0, abs_dividend};
        quotient    <= 8'd0;
        remainder   <= 8'd0;
        cnt         <= 4'd0;
        start_cnt   <= 1'b1;
    end else if (start_cnt) begin
        if (cnt == 4'd8) begin
            start_cnt    <= 1'b0;
            res_valid    <= 1'b1;
            remainder    <= sr[15:8];
            if (sign && neg_result) begin
                result    <= {~remainder + 1'b1, quotient};
            end else begin
                result    <= {remainder, quotient};
            end
        end else begin
            cnt          <= cnt + 1'b1;
            if (sr[15:8] >= abs_divisor) begin
                sr        <= {sr[15:8] - abs_divisor, sr[7:0] | (1'b1 << (8 - cnt))};
                quotient  <= quotient + (1'b1 << (8 - cnt));
            end else begin
                sr        <= {sr[15:8], sr[7:0] | (1'b1 << (8 - cnt))};
            end
        end
    end else if (res_valid && !opn_valid) begin
        res_valid    <= 1'b0;
    end
end

endmodule