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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg [15:0] sr;
reg [2:0] cnt;
reg start_cnt;
reg [15:0] temp_sr;
reg [7:0] remainder;
reg [7:0] quotient;

assign res_valid = (cnt == 8 && start_cnt == 1);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        neg_divisor <= 0;
        sr <= 0;
        cnt <= 0;
        start_cnt <= 0;
        temp_sr <= 0;
        remainder <= 0;
        quotient <= 0;
    end else if (opn_valid &&!res_valid) begin
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        if (sign) begin
            neg_divisor <= -divisor;
            sr <= {dividend[7], dividend};
        end else begin
            neg_divisor <= -divisor;
            sr <= {1'b0, dividend};
        end
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            cnt <= 0;
            start_cnt <= 0;
            remainder <= sr[15:8];
            quotient <= sr[7:0];
        end else begin
            if (sr[15] == 0) begin
                temp_sr <= {sr[15:1], 1'b0};
            end else begin
                temp_sr <= {sr[15:8] + neg_divisor, sr[7:0], 1'b0};
            end
            if (temp_sr[15]) begin
                sr <= {1'b1, temp_sr[14:1]};
            end else begin
                sr <= {1'b0, temp_sr[14:1]};
            end
            cnt <= cnt + 1;
        end
    end
end

assign result = {remainder, quotient};

endmodule