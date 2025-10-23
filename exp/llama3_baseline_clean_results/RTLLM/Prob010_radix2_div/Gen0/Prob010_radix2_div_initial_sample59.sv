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

reg [15:0] sr;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] temp_dividend;
reg [7:0] temp_divisor;

assign res_valid = (cnt == 8)? 1'b1 : 1'b0;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        sr <= 16'd0;
        neg_divisor <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'b0;
        temp_dividend <= 8'd0;
        temp_divisor <= 8'd0;
    end else if(opn_valid &&!res_valid) begin
        if(sign) begin
            temp_dividend <= (dividend[7] == 1'b1)? (~dividend + 1) : dividend;
            temp_divisor <= (divisor[7] == 1'b1)? (~divisor + 1) : divisor;
        end else begin
            temp_dividend <= dividend;
            temp_divisor <= divisor;
        end
        sr <= {1'b0, temp_dividend};
        neg_divisor <= (~temp_divisor + 1);
        cnt <= 3'd1;
        start_cnt <= 1'b1;
    end else if(start_cnt) begin
        if(cnt == 8) begin
            sr <= {sr[15:8], sr[7:0]};
            cnt <= 3'd0;
            start_cnt <= 1'b0;
        end else begin
            reg [8:0] sub;
            sub <= sr[15:8] - neg_divisor;
            if(sub[8]) begin
                sr <= {1'b1, sr[15:1]};
            end else begin
                sr <= {1'b0, (sr[15:8] - neg_divisor)[7:0], sr[7:1]};
            end
            cnt <= cnt + 1;
        end
    end
end

always @(posedge clk) begin
    if(res_valid) begin
        result <= {sr[15:8], sr[7:0]};
    end
end

endmodule