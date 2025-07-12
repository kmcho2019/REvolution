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

reg [7:0] SR; // shift register
reg [7:0] NEG_DIVISOR; // negated absolute value of divisor
reg [2:0] cnt; // counter
reg start_cnt; // flag to start division
reg [7:0] abs_dividend; // absolute value of dividend
reg [7:0] abs_divisor; // absolute value of divisor
reg [15:0] temp_result; // temporary result

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 8'b0;
        NEG_DIVISOR <= 8'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
    end else begin
        if (opn_valid && !res_valid) begin
            // save inputs
            abs_dividend <= (sign) ? {~dividend[7], dividend[7:0]} + 1 : dividend;
            abs_divisor <= (sign) ? {~divisor[7], divisor[7:0]} + 1 : divisor;
            NEG_DIVISOR <= (sign) ? ~(abs_divisor) + 1 : ~abs_divisor + 1;
            SR <= {1'b0, abs_dividend}; // initialize shift register
            cnt <= 1;
            start_cnt <= 1'b1;
        end else if (start_cnt) begin
            if (cnt == 8) begin
                // division complete
                cnt <= 3'b0;
                start_cnt <= 1'b0;
                temp_result <= {SR[15:8], SR[7:0]};
                res_valid <= 1'b1;
            end else begin
                // update shift register
                if (SR[7:0] >= abs_divisor) begin
                    SR <= {SR[6:0], 1'b1};
                end else begin
                    SR <= {SR[6:0], 1'b0};
                end
                SR <= SR - abs_divisor;
                SR <= {SR[14:0], SR[15]};
                cnt <= cnt + 1;
            end
        end else if (res_valid && !opn_valid) begin
            res_valid <= 1'b0;
        end
    end
end

assign result = (sign) ? ({(~temp_result[7]), temp_result[7:0]} + 1) : temp_result;

endmodule