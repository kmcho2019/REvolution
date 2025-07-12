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

reg [15:0] sr;  // Shift register to hold the dividend
reg [7:0] neg_divisor;  // Negated absolute value of the divisor
reg [7:0] quotient;  // Quotient of the division
reg [2:0] cnt;  // Counter to control the division process
reg start_div;  // Flag to start the division process
reg [7:0] temp_dividend;  // Temporary register to hold the dividend
reg [7:0] temp_divisor;  // Temporary register to hold the divisor

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        sr <= 0;
        neg_divisor <= 0;
        quotient <= 0;
        cnt <= 0;
        start_div <= 0;
        temp_dividend <= 0;
        temp_divisor <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Initialize the division process
            if (sign) begin
                // Signed division
                temp_dividend <= (dividend[7] == 1'b0) ? dividend : ~dividend + 1;
                temp_divisor <= (divisor[7] == 1'b0) ? divisor : ~divisor + 1;
            end else begin
                // Unsigned division
                temp_dividend <= dividend;
                temp_divisor <= divisor;
            end
            neg_divisor <= ~temp_divisor + 1;
            sr <= {1'b0, temp_dividend};  // Shift the dividend left by one bit
            quotient <= 0;
            cnt <= 1;
            start_div <= 1;
        end else if (start_div) begin
            // Perform the division process
            if (cnt < 8) begin
                if (sr[15:8] >= temp_divisor) begin
                    sr[15:8] <= sr[15:8] - temp_divisor;
                    quotient <= quotient + (1 << (8 - cnt));
                end
                sr <= {sr[7:0], 1'b0};  // Shift the shift register left
                cnt <= cnt + 1;
            end else begin
                // Division is complete
                res_valid <= 1;
                result <= {sr[15:8], quotient};  // Update the result
                start_div <= 0;
            end
        end
    end
end

endmodule