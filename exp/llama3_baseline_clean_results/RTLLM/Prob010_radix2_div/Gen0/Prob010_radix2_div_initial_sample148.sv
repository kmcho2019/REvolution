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

reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [7:0] neg_divisor;
reg [7:0] sr_quotient;
reg [7:0] sr_remainder;
reg [3:0] cnt;
reg start_cnt;

reg [15:0] shift_register;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        res_valid <= 1'b0;
        cnt <= 4'b0000;
        start_cnt <= 1'b0;
        shift_register <= 16'b0000000000000000;
    end else if(opn_valid && !res_valid) begin
        // Initialize the shift register with the absolute value of the dividend shifted left by one bit
        abs_dividend <= (sign) ? {~dividend[7], dividend[7:0]} + 1'b1 : dividend;
        abs_divisor <= (sign) ? {~divisor[7], divisor[7:0]} + 1'b1 : divisor;
        neg_divisor <= ~abs_divisor + 1'b1;
        shift_register <= {1'b0, abs_dividend};
        cnt <= 4'b0001;
        start_cnt <= 1'b1;
    end else if(start_cnt) begin
        if(cnt == 8) begin
            // Division is complete, update the result and reset the counter
            sr_quotient <= shift_register[7:0];
            sr_remainder <= shift_register[15:8];
            result <= {sr_remainder, sr_quotient};
            res_valid <= 1'b1;
            cnt <= 4'b0000;
            start_cnt <= 1'b0;
        end else begin
            // Perform the subtraction and update the shift register
            reg [8:0] sub_result;
            sub_result <= {1'b0, shift_register[15:8]} - abs_divisor;
            if(sub_result[8]) begin
                // If there is a borrow, the result is negative, so we need to add the divisor back
                shift_register <= {1'b1, shift_register[15:8]} + abs_divisor;
            end else begin
                // If there is no borrow, the result is non-negative, so we can shift the register to the left
                shift_register <= {sub_result[7:0], 1'b0} << 1;
            end
            cnt <= cnt + 1'b1;
        end
    end else if(res_valid && !opn_valid) begin
        // Reset the result validity when the result is consumed
        res_valid <= 1'b0;
    end
end

endmodule