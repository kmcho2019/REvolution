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

reg [7:0] saved_dividend;
reg [7:0] saved_divisor;
reg [15:0] sr;
reg [7:0] neg_divisor;
reg [3:0] cnt;
reg start_cnt;
reg [7:0] quotient;
reg [7:0] remainder;

assign result = {remainder, quotient};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        cnt <= 4'd0;
        start_cnt <= 1'b0;
        sr <= 16'd0;
    end else if (opn_valid &&!res_valid) begin
        saved_dividend <= (sign && dividend[7])? ~dividend + 1 : dividend;
        saved_divisor <= (sign && divisor[7])? ~divisor + 1 : divisor;
        neg_divisor <= ~saved_divisor + 1;
        sr <= {1'b0, saved_dividend};
        cnt <= 4'd1;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        if (cnt == 8'd8) begin
            quotient <= sr[7:0];
            remainder <= sr[15:8];
            res_valid <= 1'b1;
            cnt <= 4'd0;
            start_cnt <= 1'b0;
        end else begin
            reg [8:0] sub;
            reg borrow;
            sub := sr[15:8] - saved_divisor;
            borrow := sub[8];
            sr <= {borrow, sr[15:8] - (borrow? neg_divisor : saved_divisor), sr[7:1]};
            cnt <= cnt + 1;
        end
    end else if (res_valid &&!opn_valid) begin
        res_valid <= 1'b0;
    end
end

endmodule