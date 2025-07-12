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

reg [7:0] SR; // Shift Register
reg [7:0] NEG_DIVISOR; // Negated Absolute Value of Divisor
reg [2:0] cnt; // Counter
reg start_cnt; // Start Counter Flag
reg [7:0] abs_dividend; // Absolute Value of Dividend
reg [7:0] abs_divisor; // Absolute Value of Divisor
reg signed [7:0] s_dividend; // Signed Dividend
reg signed [7:0] s_divisor; // Signed Divisor
reg [7:0] quotient; // Quotient
reg [7:0] remainder; // Remainder
reg res_valid_reg; // Result Valid Register

assign res_valid = res_valid_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid_reg <= 0;
    end else if (opn_valid && !res_valid_reg) begin
        // Initialize Registers
        if (sign) begin
            s_dividend <= signed'(dividend);
            s_divisor <= signed'(divisor);
            abs_dividend <= (s_dividend < 0) ? -s_dividend : s_dividend;
            abs_divisor <= (s_divisor < 0) ? -s_divisor : s_divisor;
        end else begin
            abs_dividend <= dividend;
            abs_divisor <= divisor;
        end
        SR <= {1'b0, abs_dividend}; // Initialize Shift Register with Absolute Value of Dividend
        NEG_DIVISOR <= (~abs_divisor) + 1; // Negated Absolute Value of Divisor (2's Complement)
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        // Division Process
        if (cnt == 8) begin
            // Division Complete
            cnt <= 0;
            start_cnt <= 0;
            res_valid_reg <= 1;
            remainder <= SR[7:0];
            quotient <= SR[15:8];
            if (sign && ((s_dividend < 0 && s_divisor > 0) || (s_dividend > 0 && s_divisor < 0))) begin
                result <= {remainder, ~quotient + 1};
            end else begin
                result <= {remainder, quotient};
            end
        end else begin
            // Update Shift Register and Counter
            reg [8:0] temp;
            temp <= SR[15:8] - abs_divisor;
            if (temp[8]) begin
                SR <= {1'b1, SR[14:0]};
            end else begin
                SR <= {1'b0, SR[14:0]} + {8'b0, 1'b1};
            end
            cnt <= cnt + 1;
        end
    end else if (res_valid_reg && !opn_valid) begin
        // Result Consumed, Reset Registers
        res_valid_reg <= 0;
    end
end

endmodule