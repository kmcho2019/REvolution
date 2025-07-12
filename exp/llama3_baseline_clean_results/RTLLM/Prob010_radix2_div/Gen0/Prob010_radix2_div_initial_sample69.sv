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

reg [15:0] sr; // shift register
reg [7:0] neg_divisor; // negated absolute value of the divisor
reg [2:0] cnt; // counter
reg start_cnt; // start the division counter
reg [7:0] abs_dividend; // absolute value of the dividend
reg [7:0] abs_divisor; // absolute value of the divisor
reg sign_result; // sign of the result
reg [15:0] result_reg; // result register

always @(*) begin
    if (sign) begin
        abs_dividend = (dividend[7] ? ~dividend + 1 : dividend);
        abs_divisor = (divisor[7] ? ~divisor + 1 : divisor);
        sign_result = dividend[7] ^ divisor[7];
    end else begin
        abs_dividend = dividend;
        abs_divisor = divisor;
        sign_result = 1'b0;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        start_cnt <= 1'b0;
        cnt <= 3'b000;
        sr <= 16'b0;
        result_reg <= 16'b0;
    end else if (opn_valid && !res_valid) begin
        start_cnt <= 1'b1;
        cnt <= 3'b001;
        sr <= {1'b0, abs_dividend};
        neg_divisor <= (abs_divisor == 8'b0 ? 8'b0 : ~abs_divisor + 1);
    end else if (start_cnt) begin
        if (cnt == 3'b100) begin
            start_cnt <= 1'b0;
            cnt <= 3'b000;
            if (sign_result)
                result_reg <= {sr[15:8], {8{1'b1}} - sr[15:8] - {8{1'b0}, abs_divisor}};
            else
                result_reg <= {sr[15:8], sr[7:0]};
            res_valid <= 1'b1;
        end else begin
            cnt <= cnt + 1'b1;
            if (sr[15] == 1'b0) begin
                sr <= {sr[14:0], 1'b0};
            end else if (sr[15] == 1'b1 && (~abs_divisor + 1) >= sr[7:0]) begin
                sr <= {sr[14:0], 1'b1};
                sr[7:0] <= sr[7:0] - (~abs_divisor + 1);
            end else begin
                sr <= {sr[14:0], 1'b0};
            end
        end
    end else if (!opn_valid && res_valid) begin
        res_valid <= 1'b0;
    end
end

assign result = result_reg;

endmodule