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

reg [15:0] SR; // Shift register
reg [7:0] NEG_DIVISOR; // Negated absolute value of divisor
reg [2:0] cnt; // Counter
reg start_cnt; // Start counter flag
reg [7:0] abs_dividend; // Absolute value of dividend
reg [7:0] abs_divisor; // Absolute value of divisor
reg sign_result; // Sign of result

// Initialize shift register with absolute value of dividend shifted left by one bit
always @(posedge clk) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        // Save inputs
        abs_dividend <= (sign) ? ~dividend + 1 : dividend;
        abs_divisor <= (sign) ? ~divisor + 1 : divisor;
        SR <= {1'b0, abs_dividend};
        NEG_DIVISOR <= ~abs_divisor + 1;
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        // Division process
        if (cnt == 8) begin
            // Division complete
            cnt <= 0;
            start_cnt <= 0;
            res_valid <= 1;
            result <= {SR[15:8], SR[7:0]};
        end else begin
            // Update shift register
            reg [8:0] temp;
            temp <= SR[15:8] - abs_divisor;
            SR <= {temp[8], temp[7:0], 1'b0};
            cnt <= cnt + 1;
        end
    end else if (res_valid && !opn_valid) begin
        // Result consumed, reset module
        res_valid <= 0;
    end
end

endmodule