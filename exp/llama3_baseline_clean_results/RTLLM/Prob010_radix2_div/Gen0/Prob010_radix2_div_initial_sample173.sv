module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [7:0] SR; // shift register
reg [7:0] NEG_DIVISOR; // negated absolute value of divisor
reg [2:0] cnt; // counter
reg start_cnt; // start counter flag
reg [7:0] dividend_reg; // registered dividend
reg [7:0] divisor_reg; // registered divisor
reg res_valid_reg; // registered res_valid

// initialize variables
initial begin
    SR = 8'd0;
    NEG_DIVISOR = 8'd0;
    cnt = 3'd0;
    start_cnt = 1'd0;
    dividend_reg = 8'd0;
    divisor_reg = 8'd0;
    res_valid_reg = 1'd0;
end

always @(posedge clk) begin
    if (rst) begin
        SR <= 8'd0;
        NEG_DIVISOR <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        res_valid_reg <= 1'd0;
    end else begin
        // operation start
        if (opn_valid && !res_valid_reg) begin
            if (sign) begin
                dividend_reg <= dividend[7] ? -dividend : dividend;
                divisor_reg <= divisor[7] ? -divisor : divisor;
            end else begin
                dividend_reg <= dividend;
                divisor_reg <= divisor;
            end
            SR <= {1'd0, dividend_reg};
            NEG_DIVISOR <= ~divisor_reg + 1'd1;
            cnt <= 3'd1;
            start_cnt <= 1'd1;
        end

        // division process
        if (start_cnt) begin
            if (cnt == 3'd8) begin
                cnt <= 3'd0;
                start_cnt <= 1'd0;
                result <= {SR[15:8], SR[7:0]};
                res_valid_reg <= 1'd1;
            end else begin
                if (SR[15:8] >= NEG_DIVISOR) begin
                    SR <= {SR[14:0], 1'd1};
                end else begin
                    SR <= {SR[14:0], 1'd0};
                end
                SR <= SR - NEG_DIVISOR;
                cnt <= cnt + 3'd1;
            end
        end

        // result validity
        if (rst || !opn_valid) begin
            res_valid_reg <= 1'd0;
        end
    end
end

assign res_valid = res_valid_reg;

endmodule