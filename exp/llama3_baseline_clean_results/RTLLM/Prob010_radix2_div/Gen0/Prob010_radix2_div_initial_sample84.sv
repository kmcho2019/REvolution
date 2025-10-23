module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [15:0] SR;
reg [7:0] NEG_DIVISOR;
reg [3:0] cnt;
reg start_cnt;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        cnt <= 4'd0;
        start_cnt <= 1'b0;
    end else begin
        if (opn_valid && !res_valid) begin
            if (sign) begin // signed division
                SR <= {{8{1'b0}}, dividend[7] ? ~dividend + 1 : dividend};
                NEG_DIVISOR <= divisor[7] ? ~divisor + 1 : divisor;
            end else begin // unsigned division
                SR <= {8'b0, dividend};
                NEG_DIVISOR <= {8'b0} + divisor;
            end
            cnt <= 4'd1;
            start_cnt <= 1'b1;
        end

        if (start_cnt) begin
            if (cnt == 4'd8) begin
                cnt <= 4'd0;
                start_cnt <= 1'b0;
                result <= {SR[15:8], SR[7:0]};
                res_valid <= 1'b1;
            end else begin
                cnt <= cnt + 1;
                if (SR[15:8] >= NEG_DIVISOR) begin
                    SR <= {SR[14:0], 1'b1} - {NEG_DIVISOR, 8'b0};
                end else begin
                    SR <= {SR[14:0], 1'b0} + {8'b0, 1'b0};
                end
            end
        end
    end
end

endmodule