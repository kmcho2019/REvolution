module radix2_div(
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output          res_valid,
    output  [15:0]  result
);

reg [7:0] sr_dividend;
reg [7:0] sr_divisor;
reg [8:0] sr;
reg [3:0] cnt;
reg       start_cnt;
reg [7:0] neg_divisor;
reg       carry_out;

always @(posedge clk) begin
    if (rst) begin
        sr_dividend <= 0;
        sr_divisor <= 0;
        sr <= 0;
        cnt <= 0;
        start_cnt <= 0;
        neg_divisor <= 0;
        carry_out <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        sr_dividend <= dividend;
        sr_divisor <= divisor;
        sr <= {1'b0, abs(sign ? $signed(dividend) : unsigned'(dividend))};
        neg_divisor <= ~abs(sign ? $signed(divisor) : unsigned'(divisor)) + 1;
        cnt <= 1;
        start_cnt <= 1;
        res_valid <= 0;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            cnt <= 0;
            start_cnt <= 0;
            sr <= {sr[7:0], sr[8]};
            res_valid <= 1;
        end else begin
            carry_out <= (sr[8] ? 1'b0 : (sr[7:0] >= neg_divisor));
            sr <= {carry_out, sr[7:0] - (carry_out ? neg_divisor : 0), 1'b0};
            cnt <= cnt + 1;
        end
    end else if (res_valid && !opn_valid) begin
        res_valid <= 0;
    end
end

assign result = (sign ? 
                {($signed(sr[7:0]) < 0) ? 8'hFF : 8'h00, sr[7:0]} : 
                {8'h00, sr[7:0]});

function [7:0] abs;
    input [7:0] a;
    begin
        abs = (a[7] ? ~a + 1 : a);
    end
endfunction

endmodule