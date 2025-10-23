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
reg [15:0] SR;
reg [7:0] NEG_DIVISOR;
reg [3:0] cnt;
reg start_cnt;
reg valid_result;
wire [7:0] abs_dividend;
wire [7:0] abs_divisor;

assign abs_dividend = sign ? (dividend[7] ? (~dividend + 1) : dividend) : dividend;
assign abs_divisor = sign ? (divisor[7] ? (~divisor + 1) : divisor) : divisor;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        saved_dividend <= 8'd0;
        saved_divisor <= 8'd0;
        SR <= 16'd0;
        NEG_DIVISOR <= 8'd0;
        cnt <= 4'd0;
        start_cnt <= 1'b0;
        valid_result <= 1'b0;
        res_valid <= 1'b0;
    end else begin
        if(opn_valid && !res_valid) begin
            saved_dividend <= dividend;
            saved_divisor <= divisor;
            SR <= {1'b0, abs_dividend};
            NEG_DIVISOR <= ~abs_divisor + 1;
            cnt <= 4'd1;
            start_cnt <= 1'b1;
            valid_result <= 1'b0;
        end else if(start_cnt) begin
            if(cnt == 4'd8) begin
                cnt <= 4'd0;
                start_cnt <= 1'b0;
                valid_result <= 1'b1;
            end else begin
                if(SR[15:8] >= NEG_DIVISOR) begin
                    SR <= {SR[14:0], 1'b1};
                end else begin
                    SR <= {SR[14:0], 1'b0};
                end
                SR <= SR << 1;
                SR[7:0] <= SR[7:0] - NEG_DIVISOR;
                cnt <= cnt + 1;
            end
        end
        if(valid_result && !res_valid) begin
            res_valid <= 1'b1;
            result <= {SR[15:8], SR[7:0]};
        end else if(res_valid && !opn_valid) begin
            res_valid <= 1'b0;
        end
    end
end

endmodule