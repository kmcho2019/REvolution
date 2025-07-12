module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output [15:0] result
);

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [15:0] sr;  // Shift register
reg [7:0] neg_divisor;  // Negated absolute value of the divisor
reg [3:0] cnt;  // Counter
reg start_div;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_div <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        // Save the inputs dividend and divisor
        if (sign) begin
            // Signed division
            dividend_reg <= {dividend[7] ? 8'hff : 8'h00} + dividend;
            divisor_reg <= {divisor[7] ? 8'hff : 8'h00} + divisor;
        end else begin
            // Unsigned division
            dividend_reg <= dividend;
            divisor_reg <= divisor;
        end
        sr <= dividend_reg << 1;
        neg_divisor <= divisor_reg;
        cnt <= 1;
        start_div <= 1;
    end else if (start_div) begin
        // Perform the division process
        if (cnt == 8) begin
            // Division complete
            res_valid <= 1;
            result <= {sr[15:8], sr[7:0]};
            start_div <= 0;
        end else begin
            reg [8:0] subtraction;
            subtraction = {1'b0, sr[15:8]} - neg_divisor;
            if (subtraction[8]) begin
                // No borrow
                sr <= {1'b0, sr[15:8]} << 1;
            end else begin
                // Borrow
                sr <= {1'b1, sr[15:8]} + (neg_divisor << 1);
            end
            cnt <= cnt + 1;
        end
    end
end

endmodule