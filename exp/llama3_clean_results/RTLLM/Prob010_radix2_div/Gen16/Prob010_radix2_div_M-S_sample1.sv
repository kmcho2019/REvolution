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

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        sr <= 0;
        neg_divisor <= 0;
        quotient <= 0;
        cnt <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Initialize the shift register and negated divisor
            sr <= {1'b0, dividend};  // Shift the dividend left by one bit
            neg_divisor <= ~divisor + 1;  // Calculate the negated absolute value of the divisor
            quotient <= 0;
            cnt <= 1;
        end else if (cnt < 8) begin
            // Perform the division process
            if (sr[15:8] >= divisor) begin
                sr[15:8] <= sr[15:8] - divisor;
                quotient <= quotient + (1 << (8 - cnt));
            end
            sr <= {sr[7:0], 1'b0};  // Shift the shift register left
            cnt <= cnt + 1;
        end else begin
            // Division is complete
            res_valid <= 1;
            result <= {sr[15:8], quotient};  // Update the result
        end
    end
end

endmodule