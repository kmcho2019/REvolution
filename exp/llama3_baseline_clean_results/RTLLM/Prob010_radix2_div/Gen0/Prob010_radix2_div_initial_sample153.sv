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

reg [7:0] SR;  // Shift register
reg [7:0] NEG_DIVISOR;  // Negated absolute value of divisor
reg [3:0] cnt;  // Counter
reg start_cnt;  // Start counter flag
reg [7:0] temp_dividend;  // Temporary dividend
reg [7:0] temp_divisor;  // Temporary divisor
reg temp_sign;  // Temporary sign

always @ (posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        start_cnt <= 0;
        cnt <= 0;
        SR <= 0;
    end else if (opn_valid && !res_valid) begin
        temp_dividend <= sign ? {~dividend[7], dividend[7:0]} + 1 : dividend;
        temp_divisor <= sign ? {~divisor[7], divisor[7:0]} + 1 : divisor;
        temp_sign <= sign;
        SR <= {1'b0, temp_dividend};
        NEG_DIVISOR <= ~temp_divisor + 1;
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            cnt <= 0;
            start_cnt <= 0;
            if (temp_sign) begin
                result <= {SR[7:0], SR[15:8]};
            end else begin
                result <= {SR[7:0], SR[15:8]};
            end
            res_valid <= 1;
        end else begin
            reg [8:0] temp_SR;
            temp_SR <= SR + NEG_DIVISOR;
            if (temp_SR[8]) begin
                SR <= {1'b0, SR[15:1]} | {8{temp_SR[7]}};
            end else begin
                SR <= {1'b1, SR[15:1]};
            end
            cnt <= cnt + 1;
        end
    end else if (res_valid) begin
        res_valid <= 0;
    end
end

endmodule