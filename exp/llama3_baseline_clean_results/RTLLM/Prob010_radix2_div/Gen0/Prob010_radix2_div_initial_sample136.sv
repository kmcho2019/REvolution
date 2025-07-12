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

reg [7:0] SR; // Shift Register
reg [7:0] NEG_DIVISOR; // Negated absolute value of divisor
reg [2:0] cnt; // Counter for division steps
reg start_cnt; // Flag to start division
reg [7:0] abs_dividend; // Absolute value of dividend
reg [7:0] abs_divisor; // Absolute value of divisor
reg [15:0] temp_result; // Temporary result

always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        abs_dividend <= (sign) ? {~dividend[7], dividend[7:0]} + 1 : dividend;
        abs_divisor <= (sign) ? {~divisor[7], divisor[7:0]} + 1 : divisor;
        NEG_DIVISOR <= ~abs_divisor + 1;
        SR <= {1'b0, abs_dividend}; // Initialize SR with absolute dividend shifted left by one bit
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            temp_result <= {SR[15:8], SR[7:0]};
            start_cnt <= 0;
            cnt <= 0;
        end else begin
            if (SR[15:8] >= NEG_DIVISOR) begin
                SR <= {SR[7:0], 1'b1}; // Shift SR left and insert carry-out (1)
            end else begin
                SR <= {SR[7:0], 1'b0}; // Shift SR left and insert carry-out (0)
            end
            cnt <= cnt + 1;
        end
    end
end

always @(posedge clk) begin
    if (start_cnt && cnt == 8) begin
        if (sign) begin
            if (dividend[7] != divisor[7]) begin
                result <= {~temp_result[15:8] + 1, temp_result[7:0]};
            end else begin
                result <= temp_result;
            end
        end else begin
            result <= temp_result;
        end
        res_valid <= 1;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
    end else if (res_valid && !opn_valid) begin
        res_valid <= 0;
    end
end

endmodule