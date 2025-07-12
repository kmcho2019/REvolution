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

reg [15:0] sr;  // Shift register
reg [7:0] neg_divisor;  // Negated absolute value of the divisor
reg [3:0] cnt;  // Counter

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        // Save the inputs dividend and divisor
        if (sign) begin
            // Signed division
            sr <= ({dividend[7] ? 8'hff : 8'h00} + dividend) << 1;
            neg_divisor <= ({divisor[7] ? 8'hff : 8'h00} + divisor);
        end else begin
            // Unsigned division
            sr <= dividend << 1;
            neg_divisor <= divisor;
        end
        cnt <= 1;
    end else if (cnt != 0) begin
        // Perform the division process
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
        if (cnt == 8) begin
            // Division complete
            res_valid <= 1;
            result <= {sr[15:8], sr[7:0]};
            cnt <= 0;
        end
    end
end

endmodule