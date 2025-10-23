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

reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [7:0] neg_divisor;
reg [8:0] sr; // Shift register with an extra bit for carry
reg [3:0] cnt;
reg start_cnt;
reg [15:0] res;

assign res_valid = (cnt == 8 && start_cnt == 1);
assign result = res;

always @(posedge clk) begin
    if (rst) begin
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        res <= 0;
        sr <= 0;
    end else if (opn_valid && !res_valid) begin
        abs_dividend <= (sign ? {{7{dividend[7]}}, dividend[7:0]} : dividend);
        abs_divisor <= (sign ? {{7{divisor[7]}}, divisor[7:0]} : divisor);
        neg_divisor <= ~abs_divisor + 1;
        sr <= {1'b0, abs_dividend};
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            res <= {sr[8:1], sr[0]};
            start_cnt <= 0;
            cnt <= 0;
        end else begin
            if (sr[8] == 0) begin // No carry, subtract NEG_DIVISOR
                sr <= {sr[7:0] + neg_divisor, 0};
            end else begin // Carry, add abs_divisor
                sr <= {sr[7:0] - neg_divisor, 1};
            end
            cnt <= cnt + 1;
            sr <= {sr[7:0], sr[8]};
        end
    end
end

endmodule