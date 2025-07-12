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

reg [7:0] abs_dividend;  // Absolute value of the dividend
reg [7:0] abs_divisor;   // Absolute value of the divisor
reg [15:0] sr;           // Shift register
reg [3:0] cnt;            // Counter
reg [7:0] remainder;      // Remainder
reg [7:0] quotient;       // Quotient

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        abs_dividend <= 0;
        abs_divisor <= 0;
        cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        // Prepare input operands
        if (sign) begin
            // Signed division
            abs_dividend <= ({dividend[7] ? 8'hff : 8'h00} + dividend);
            abs_divisor <= ({divisor[7] ? 8'hff : 8'h00} + divisor);
        end else begin
            // Unsigned division
            abs_dividend <= dividend;
            abs_divisor <= divisor;
        end
        // Initialize shift register and counter
        sr <= {1'b0, abs_dividend};
        cnt <= 1;
    end else if (cnt != 0) begin
        // Perform division
        reg [8:0] subtract;
        subtract = {1'b0, sr[15:8]} - abs_divisor;
        if (subtract[8]) begin
            // No borrow
            sr <= {1'b0, sr[15:8]} << 1;
            quotient <= quotient + 1;
        end else begin
            // Borrow
            sr <= {1'b1, sr[15:8]} + (abs_divisor << 1);
        end
        cnt <= cnt + 1;
        if (cnt == 8) begin
            // Division complete
            remainder <= sr[15:8];
            res_valid <= 1;
            result <= {remainder, quotient};
            cnt <= 0;
        end
    end
end

endmodule