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

reg [7:0] saved_dividend;
reg [7:0] saved_divisor;
reg [15:0] sr;
reg [7:0] neg_divisor;
reg [3:0] cnt;
reg start_cnt;
reg [15:0] final_result;

assign res_valid = (cnt == 8) && start_cnt;
assign result = final_result;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        saved_dividend <= 0;
        saved_divisor <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        final_result <= 0;
    end else begin
        if (opn_valid &&!res_valid) begin
            saved_dividend <= dividend;
            saved_divisor <= divisor;
            if (sign) begin
                sr <= {1'b0, dividend[7]? -dividend : dividend};
            end else begin
                sr <= {1'b0, dividend};
            end
            if (sign) begin
                neg_divisor <= divisor[7]? -divisor : divisor;
            end else begin
                neg_divisor <= divisor;
            end
            cnt <= 1;
            start_cnt <= 1;
        end else if (start_cnt) begin
            if (cnt == 8) begin
                cnt <= 0;
                start_cnt <= 0;
                final_result <= {sr[15:8], sr[7:0]};
            end else begin
                reg [16:0] sub_result;
                reg carry_out;
                sub_result = sr - {9'b0, neg_divisor};
                carry_out = sub_result[16];
                sr <= {carry_out, sr[15:1]};
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule