module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [7:0] SR; // Shift Register
reg [7:0] NEG_DIVISOR; // Negated absolute value of the divisor
reg [3:0] cnt; // Counter
reg start_cnt; // Start counter flag
reg [7:0] abs_dividend; // Absolute value of the dividend
reg [7:0] abs_divisor; // Absolute value of the divisor

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        cnt <= 0;
        start_cnt <= 0;
        SR <= 0;
    end else if (opn_valid && !res_valid) begin
        // Operation Start
        abs_dividend <= (sign ? {~dividend[7] + 1, dividend[6:0]} : dividend);
        abs_divisor <= (sign ? {~divisor[7] + 1, divisor[6:0]} : divisor);
        NEG_DIVISOR <= (sign ? {~abs_divisor[7] + 1, abs_divisor[6:0]} : {8'b0} - abs_divisor);
        SR <= {1'b0, abs_dividend};
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        // Division Process
        if (cnt == 8) begin
            // Division Complete
            cnt <= 0;
            start_cnt <= 0;
            result <= {SR[15:8], SR[7:0]};
            res_valid <= 1;
        end else begin
            // Update SR and Counter
            reg [8:0] sub_result;
            sub_result <= {SR[15:8], SR[7:0]} - {1'b0, NEG_DIVISOR};
            if (sub_result[8]) begin
                SR <= {SR[14:0], 1'b1};
            end else begin
                SR <= {SR[14:0], 1'b0};
            end
            SR <= {SR[15:1], 1'b0};
            cnt <= cnt + 1;
        end
    end else if (res_valid) begin
        // Result Validity
        res_valid <= 0;
    end
end

endmodule