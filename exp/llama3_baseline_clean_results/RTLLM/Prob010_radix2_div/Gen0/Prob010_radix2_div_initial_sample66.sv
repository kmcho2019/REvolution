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

reg [7:0] SR;
reg [7:0] NEG_DIVISOR;
reg [3:0] cnt;
reg start_cnt;
reg [15:0] temp_result;

assign res_valid = (cnt == 0) && (start_cnt == 0);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        result <= 0;
        temp_result <= 0;
    end else if (opn_valid &&!res_valid) begin
        if (sign) begin
            SR <= {{1'b0}, (dividend[7]? -dividend : dividend)} << 1;
            NEG_DIVISOR <= (divisor[7]? -divisor : divisor);
        end else begin
            SR <= {1'b0, dividend} << 1;
            NEG_DIVISOR <= {8{1'b0}} - divisor;
        end
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            start_cnt <= 0;
            cnt <= 0;
            if (sign) begin
                if (SR[15]) begin
                    temp_result <= {SR[15:8], (SR[7:0] + NEG_DIVISOR)[7:0]};
                end else begin
                    temp_result <= {SR[15:8], SR[7:0]};
                end
            end else begin
                temp_result <= {SR[15:8], SR[7:0]};
            end
            result <= temp_result;
        end else begin
            reg [8:0] sub_result;
            sub_result <= SR[15:8] - NEG_DIVISOR;
            if (sub_result[8]) begin
                SR <= {1'b1, SR[15:1]};
            end else begin
                SR <= {1'b0, (SR[15:8] - NEG_DIVISOR)[7:0], SR[7:1]};
            end
            cnt <= cnt + 1;
        end
    end
end

endmodule