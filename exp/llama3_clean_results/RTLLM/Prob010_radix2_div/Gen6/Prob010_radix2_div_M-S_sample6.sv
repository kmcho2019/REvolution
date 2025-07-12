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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [15:0] shift_reg;  // 8 bits for remainder, 8 bits for quotient
reg [3:0] cnt;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        cnt <= 0;
        shift_reg <= 0;
    end else begin
        if (opn_valid &&!res_valid) begin
            // Save inputs and initialize shift register
            dividend_reg <= dividend;
            divisor_reg <= divisor;
            shift_reg <= {8'b0, dividend_reg};  // Initialize with dividend
            cnt <= 1;
            res_valid <= 0;
        end else if (cnt < 8) begin
            // Perform subtraction and update shift register
            if (shift_reg[15:8] >= divisor_reg) begin
                shift_reg <= {shift_reg[15:8] - divisor_reg, 1'b1, shift_reg[7:1]};  // Update remainder and quotient
            end else begin
                shift_reg <= {shift_reg[15:8], 1'b0, shift_reg[7:1]};  // Update remainder and quotient
            end
            cnt <= cnt + 1;
        end else if (cnt == 8) begin
            // Division complete, update result
            result <= {shift_reg[15:8], shift_reg[7:0]};  // Remainder in upper 8 bits, quotient in lower 8 bits
            res_valid <= 1;
            cnt <= 0;
        end else if (!opn_valid && res_valid) begin
            // Reset when result is consumed
            res_valid <= 0;
        end
    end
end

endmodule