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

reg [7:0] SR; // Shift register
reg [7:0] NEG_DIVISOR; // Negated absolute value of the divisor
reg [2:0] cnt; // Counter
reg start_cnt; // Flag to start the division process
reg [7:0] abs_dividend; // Absolute value of the dividend
reg [7:0] abs_divisor; // Absolute value of the divisor
reg [15:0] temp_result; // Temporary result

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        // Save inputs and initialize registers
        abs_dividend <= (sign) ? {~dividend[7], dividend[7:0]} + 1 : dividend;
        abs_divisor <= (sign) ? {~divisor[7], divisor[7:0]} + 1 : divisor;
        SR <= {1'b0, abs_dividend};
        NEG_DIVISOR <= (~abs_divisor) + 1;
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete, update result and reset counters
            temp_result <= {SR[15:8], SR[7:0]};
            start_cnt <= 0;
            cnt <= 0;
            res_valid <= 1;
        end else begin
            // Update SR based on subtraction result
            if (SR[15:8] >= NEG_DIVISOR) begin
                SR <= {SR[14:0], 1};
            end else begin
                SR <= {SR[14:0], 0};
            end
            // Shift SR left and insert carry-out
            SR <= {SR[6:0], (SR[15:8] >= NEG_DIVISOR) ? 1 : 0, SR[7]};
            // Increment counter
            cnt <= cnt + 1;
        end
    end else if (res_valid && !opn_valid) begin
        // Reset res_valid when result is consumed
        res_valid <= 0;
    end
end

assign result = temp_result;

endmodule