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
reg [15:0] SR; // shift register
reg [7:0] NEG_DIVISOR;
reg [3:0] cnt;
reg start_cnt;
reg [15:0] final_result;
wire [7:0] sub_result;
wire carry_out;

assign sub_result = SR[15:8] - NEG_DIVISOR;
assign carry_out = (sub_result[7] == 1) ? 1'b0 : 1'b1;

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 1'b0;
        SR <= 16'd0;
        NEG_DIVISOR <= 8'd0;
        cnt <= 4'd0;
        start_cnt <= 1'b0;
        saved_dividend <= 8'd0;
        saved_divisor <= 8'd0;
        final_result <= 16'd0;
    end else if (opn_valid && !res_valid) begin
        saved_dividend <= dividend;
        saved_divisor <= divisor;
        SR <= {1'b0, (sign == 1'b1) ? (~dividend[7] ? dividend : (~dividend + 1)) : dividend};
        NEG_DIVISOR <= (sign == 1'b1) ? (~divisor[7] ? divisor : (~divisor + 1)) : divisor;
        cnt <= 4'd1;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        if (cnt == 4'd8) begin
            start_cnt <= 1'b0;
            cnt <= 4'd0;
            final_result <= {SR[15:8], SR[7:0]};
            res_valid <= 1'b1;
        end else begin
            if (carry_out) begin
                SR <= {carry_out, SR[15:8] + sub_result, SR[0]};
            end else begin
                SR <= {1'b0, SR[15:8], 1'b0};
            end
            cnt <= cnt + 4'd1;
        end
    end else if (res_valid) begin
        if (!opn_valid) begin
            res_valid <= 1'b0;
        end
    end
end

always @(posedge clk) begin
    if (res_valid) begin
        result <= final_result;
    end
end

endmodule