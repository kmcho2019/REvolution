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

reg [7:0] SR;
reg [7:0] NEG_DIVISOR;
reg [7:0] cnt;
reg start_cnt;
reg [15:0] temp_result;

always @ (posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        start_cnt <= 0;
        cnt <= 0;
        SR <= 0;
    end else if (opn_valid && !res_valid) begin
        if (sign) begin
            if (dividend[7])
                SR <= {1'b1, (~dividend + 1)};
            else
                SR <= {1'b0, dividend};
            if (divisor[7])
                NEG_DIVISOR <= (~divisor + 1);
            else
                NEG_DIVISOR <= divisor;
        end else begin
            SR <= {1'b0, dividend};
            NEG_DIVISOR <= divisor;
        end
        cnt <= 1;
        start_cnt <= 1;
        res_valid <= 0;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            start_cnt <= 0;
            cnt <= 0;
            if (sign) begin
                if (SR[8]) begin
                    temp_result <= {SR[15:8] + 1, SR[7:0]};
                end else begin
                    temp_result <= SR;
                end
            end else begin
                temp_result <= SR;
            end
            res_valid <= 1;
        end else begin
            if (SR[15:8] >= NEG_DIVISOR) begin
                SR <= {SR[14:0], 1'b1};
                SR[15:8] <= SR[15:8] - NEG_DIVISOR;
            end else begin
                SR <= {SR[14:0], 1'b0};
            end
            cnt <= cnt + 1;
        end
    end else if (res_valid) begin
        res_valid <= 0;
    end
end

assign result = temp_result;

endmodule