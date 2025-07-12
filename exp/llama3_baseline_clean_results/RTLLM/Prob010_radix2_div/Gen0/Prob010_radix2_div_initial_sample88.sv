module radix2_div (
    input        clk,
    input        rst,
    input        sign,
    input [7:0]  dividend,
    input [7:0]  divisor,
    input        opn_valid,
    output       res_valid,
    output [15:0] result
);

reg [7:0]  sr;  // Shift register
reg [7:0]  neg_divisor;  // Negated absolute value of divisor
reg [3:0]  cnt;  // Counter
reg        start_cnt;  // Start counter flag
reg [7:0]  abs_dividend;  // Absolute value of dividend
reg [7:0]  abs_divisor;  // Absolute value of divisor
reg [7:0]  remainder;  // Remainder
reg [7:0]  quotient;  // Quotient
reg        res_valid_reg;  // Result validity register

assign res_valid = res_valid_reg;

always @(posedge clk) begin
    if (rst) begin
        sr <= 8'b0;
        neg_divisor <= 8'b0;
        cnt <= 4'b0;
        start_cnt <= 1'b0;
        res_valid_reg <= 1'b0;
        abs_dividend <= 8'b0;
        abs_divisor <= 8'b0;
        remainder <= 8'b0;
        quotient <= 8'b0;
    end else if (opn_valid && !res_valid_reg) begin
        // Save inputs
        abs_dividend <= (sign) ? {dividend[7] ? ~dividend + 1'b1 : dividend} : dividend;
        abs_divisor <= (sign) ? {divisor[7] ? ~divisor + 1'b1 : divisor} : divisor;
        // Initialize shift register and negated divisor
        sr <= {1'b0, abs_dividend};
        neg_divisor <= ~abs_divisor + 1'b1;
        // Reset counter and start flag
        cnt <= 1;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete, update result and reset flags
            remainder <= sr[15:8];
            quotient <= sr[7:0];
            result <= {remainder, quotient};
            res_valid_reg <= 1'b1;
            cnt <= 4'b0;
            start_cnt <= 1'b0;
        end else begin
            // Perform subtraction and update shift register
            if (sr[15:8] >= neg_divisor) begin
                // Subtract and shift left
                sr <= {1'b1, (sr[15:8] - neg_divisor), sr[7:1]};
            end else begin
                // Shift left without subtracting
                sr <= {1'b0, sr[15:1]};
            end
            // Increment counter
            cnt <= cnt + 1;
        end
    end else if (res_valid_reg && !opn_valid) begin
        // Reset result validity when result is consumed
        res_valid_reg <= 1'b0;
    end
end

endmodule