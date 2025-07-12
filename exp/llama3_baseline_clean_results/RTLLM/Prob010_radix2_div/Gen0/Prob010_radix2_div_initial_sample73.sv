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

reg [7:0] SR;  // Shift register
reg [7:0] NEG_DIVISOR;  // Negated absolute value of the divisor
reg [2:0] cnt;  // Counter
reg start_cnt;  // Start counter flag
reg [7:0] abs_dividend;  // Absolute value of the dividend
reg [7:0] abs_divisor;  // Absolute value of the divisor
reg [7:0] quotient;  // Quotient
reg [7:0] remainder;  // Remainder
reg sign_dividend;  // Sign of the dividend
reg sign_divisor;  // Sign of the divisor
reg carry_out;  // Carry-out signal

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else if (opn_valid && !res_valid) begin
        // Save inputs and initialize registers
        abs_dividend <= sign ? {1'b0, ~dividend[7:0]} + 1 : dividend;
        abs_divisor <= sign ? {1'b0, ~divisor[7:0]} + 1 : divisor;
        sign_dividend <= sign ? dividend[7] : 0;
        sign_divisor <= sign ? divisor[7] : 0;
        SR <= {1'b0, abs_dividend};
        NEG_DIVISOR <= {1'b0, ~abs_divisor} + 1;
        cnt <= 1;
        start_cnt <= 1;
        res_valid <= 0;
    end else if (start_cnt) begin
        // Perform division
        if (cnt == 8) begin
            // Division complete
            start_cnt <= 0;
            cnt <= 0;
            remainder <= SR[7:0];
            quotient <= SR[8:1];
            if (sign_dividend ^ sign_divisor) begin
                quotient <= ~quotient + 1;
            end
            result <= {remainder, quotient};
            res_valid <= 1;
        end else begin
            // Update shift register and counter
            carry_out <= SR[0] ? (SR[7:1] >= NEG_DIVISOR[7:1]) : (SR[7:1] > NEG_DIVISOR[7:1]);
            SR <= {carry_out, SR[7:1]} - {8'b0, NEG_DIVISOR[7:1]} + {8'b0, carry_out};
            cnt <= cnt + 1;
        end
    end else if (res_valid) begin
        res_valid <= 0;
    end
end

endmodule