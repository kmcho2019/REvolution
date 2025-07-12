module radix2_div(
    input  clk, 
    input  rst,
    input  sign,
    input  [7:0] dividend,
    input  [7:0] divisor,
    input  opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [8:0] SR;
reg [7:0] NEG_DIVISOR;
reg [3:0] cnt;
reg start_cnt;
reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [7:0] quotient;
reg borrow;

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        start_cnt <= 0;
        cnt <= 0;
        SR <= 0;
    end else if (opn_valid && !res_valid) begin
        abs_dividend <= (sign) ? {~dividend[7], dividend[7:0]} + 1 : dividend;
        abs_divisor <= (sign) ? {~divisor[7], divisor[7:0]} + 1 : divisor;
        NEG_DIVISOR <= abs_divisor;
        SR <= {1'b0, abs_dividend};
        start_cnt <= 1'b1;
        cnt <= 1'b1;
        res_valid <= 1'b0;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            result <= {SR[8:1], quotient};
            res_valid <= 1'b1;
            start_cnt <= 1'b0;
            cnt <= 1'b0;
        end else begin
            if (SR[8] == 1'b0) begin
                borrow <= 1'b0;
                SR <= SR << 1;
                quotient <= quotient + 1;
            end else if (SR[8:1] >= NEG_DIVISOR) begin
                borrow <= 1'b1;
                SR <= (SR[7:0] - NEG_DIVISOR) << 1;
                quotient <= quotient + 1;
            end else begin
                borrow <= 1'b0;
                SR <= SR << 1;
            end
            cnt <= cnt + 1;
        end
    end else if (res_valid) begin
        if (opn_valid) begin
            res_valid <= 1'b0;
        end
    end
end

endmodule