module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [7:0] SR; // Shift Register holding the dividend and quotient
reg [7:0] NEG_DIVISOR; // Negated absolute value of the divisor
reg [2:0] cnt; // Counter to track division steps
reg start_cnt; // Flag to indicate division start
reg [7:0] abs_dividend; // Absolute value of the dividend
reg [7:0] abs_divisor; // Absolute value of the divisor

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        SR <= 8'b0;
        NEG_DIVISOR <= 8'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
    end else if (opn_valid && !res_valid) begin
        // Save inputs and initialize
        abs_dividend <= (sign) ? {~dividend[7], dividend[6:0]} + 1 : dividend;
        abs_divisor <= (sign) ? {~divisor[7], divisor[6:0]} + 1 : divisor;
        SR <= {1'b0, abs_dividend}; // Shift dividend left by one bit
        NEG_DIVISOR <= ~abs_divisor + 1;
        cnt <= 1'b1;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        // Division process
        if (cnt == 8) begin
            // Division complete, update result and signals
            cnt <= 3'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b1;
            result <= {SR[15:8], SR[7:0]}; // Remainder and quotient
        end else begin
            // Perform subtraction and update SR
            reg [8:0] sub_result;
            sub_result <= {SR[15:8], SR[7:0]} - NEG_DIVISOR;
            if (sub_result[8]) begin
                // If subtraction result is negative, no borrow
                SR <= {1'b0, SR[7:0]} << 1; // Shift SR left and insert 0
            end else begin
                // If subtraction result is non-negative, borrow
                SR <= {1'b1, SR[7:0]} << 1; // Shift SR left and insert 1
                SR[7:0] <= sub_result[7:0]; // Update SR with the result
            end
            cnt <= cnt + 1;
        end
    end else if (res_valid) begin
        // Reset res_valid when result is consumed (for simplicity, assume it's consumed on next clock)
        res_valid <= 1'b0;
    end
end

endmodule