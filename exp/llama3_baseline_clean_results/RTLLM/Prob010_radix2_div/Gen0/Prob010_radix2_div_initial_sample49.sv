module radix2_div(
    input clk, rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [7:0] abs_dividend, abs_divisor;
reg [8:0] NEG_DIVISOR;
reg [8:0] SR;
reg [3:0] cnt;
reg start_cnt;

always @(*) begin
    if (sign) begin
        abs_dividend = (dividend[7] == 1'b0) ? dividend : (~dividend + 1);
        abs_divisor = (divisor[7] == 1'b0) ? divisor : (~divisor + 1);
    end else begin
        abs_dividend = dividend;
        abs_divisor = divisor;
    end
end

always @(posedge clk) begin
    if (rst) begin
        cnt <= 4'd0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
        SR <= 9'd0;
    end else if (opn_valid && !res_valid) begin
        SR <= {1'b0, abs_dividend};
        NEG_DIVISOR <= -abs_divisor;
        cnt <= 4'd1;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        if (cnt == 4'd8) begin
            cnt <= 4'd0;
            start_cnt <= 1'b0;
            res_valid <= 1'b1;
            if (sign) begin
                if ((dividend[7] == 1'b1 && divisor[7] == 1'b1) || (dividend[7] == 1'b0 && divisor[7] == 1'b0)) begin
                    result <= {SR[8:1], SR[0]};
                end else if (dividend[7] == 1'b1 && divisor[7] == 1'b0) begin
                    result <= {~SR[8:1] + 1, ~(~SR[0] + 1)};
                end else begin
                    result <= {~SR[8:1] + 1, SR[0]};
                end
            end else begin
                result <= {SR[8:1], SR[0]};
            end
        end else begin
            cnt <= cnt + 1;
            if (SR[8] == 1'b1) begin
                SR <= {SR[8:1] + NEG_DIVISOR, 1'b1};
            end else begin
                SR <= {SR[8:1] - NEG_DIVISOR, 1'b0};
            end
            SR <= {SR[7:0], 1'b0};
        end
    end else if (res_valid) begin
        res_valid <= 1'b0;
    end
end

endmodule