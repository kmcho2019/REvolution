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

reg [15:0] SR; // shift register
reg [7:0] NEG_DIVISOR; // negated divisor
reg [3:0] cnt; // counter
reg start_cnt; // flag to start division
reg [15:0] temp_result; // temporary result
reg temp_res_valid; // temporary res_valid

always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // save inputs
            if (sign) begin
                SR <= ({8'd0, (dividend[7] ? -dividend : dividend)}) << 1;
                NEG_DIVISOR <= (divisor[7] ? -divisor : divisor);
            end else begin
                SR <= ({8'd0, dividend}) << 1;
                NEG_DIVISOR <= divisor;
            end
            cnt <= 1;
            start_cnt <= 1;
        end

        if (start_cnt) begin
            if (cnt == 8) begin
                // division complete
                cnt <= 0;
                start_cnt <= 0;
                temp_result <= {SR[15:8], SR[7:0]};
                temp_res_valid <= 1;
            end else begin
                // perform division
                reg [8:0] temp_SR;
                temp_SR <= SR[15:8] - NEG_DIVISOR;
                if (temp_SR[8]) begin
                    SR <= {1'b1, SR[15:1]};
                end else begin
                    SR <= {0, SR[15:1]} + {8'd0, 1'b1};
                end
                cnt <= cnt + 1;
            end
        end
    end
end

always @(posedge clk) begin
    if (rst) begin
        result <= 0;
        res_valid <= 0;
    end else begin
        if (temp_res_valid) begin
            result <= temp_result;
            res_valid <= 1;
        end
        if (res_valid && !opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule