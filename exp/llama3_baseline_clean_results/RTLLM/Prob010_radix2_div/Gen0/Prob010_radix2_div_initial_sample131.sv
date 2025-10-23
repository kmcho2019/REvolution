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

reg [7:0] SR; // Shift register to store dividend and quotient
reg [7:0] NEG_DIVISOR; // Negated absolute value of divisor
reg [2:0] cnt; // Counter for division steps
reg start_cnt; // Flag to start division process
reg [7:0] abs_dividend; // Absolute value of dividend
reg [7:0] abs_divisor; // Absolute value of divisor
reg signed [7:0] signed_dividend; // Signed value of dividend
reg signed [7:0] signed_divisor; // Signed value of divisor
reg [7:0] remainder; // Remainder after division

assign result = {remainder, SR[7:0]};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 8'd0;
        NEG_DIVISOR <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
        res_valid <= 1'd0;
    end else begin
        if (opn_valid &&!res_valid) begin
            // Save inputs and initialize shift register
            if (sign) begin
                signed_dividend = signed'(dividend);
                signed_divisor = signed'(divisor);
                abs_dividend = (signed_dividend < 0)? -signed_dividend : signed_dividend;
                abs_divisor = (signed_divisor < 0)? -signed_divisor : signed_divisor;
                NEG_DIVISOR = ~abs_divisor + 1;
            end else begin
                abs_dividend = dividend;
                abs_divisor = divisor;
                NEG_DIVISOR = ~abs_divisor + 1;
            end
            SR <= {1'd0, abs_dividend};
            cnt <= 1'd1;
            start_cnt <= 1'd1;
        end else if (start_cnt) begin
            // Division process
            if (cnt == 8'd8) begin
                // Division complete
                cnt <= 3'd0;
                start_cnt <= 1'd0;
                if (sign) begin
                    // Signed division
                    remainder = (signed_dividend < 0)? -SR[7:0] : SR[7:0];
                    result <= {remainder, (signed_dividend < 0 && signed_divisor < 0) || (signed_dividend >= 0 && signed_divisor >= 0)? SR[7:0] : ~SR[7:0] + 1};
                end else begin
                    // Unsigned division
                    remainder = SR[7:0];
                    result <= {remainder, SR[7:0]};
                end
                res_valid <= 1'd1;
            end else begin
                // Update shift register and counter
                reg [8:0] temp;
                temp = {1'd0, SR} - {1'd0, NEG_DIVISOR};
                if (temp[8]) begin
                    SR <= {1'd1, SR[7:0]};
                end else begin
                    SR <= {1'd0, SR[7:0]} + {1'd0, NEG_DIVISOR};
                end
                cnt <= cnt + 1'd1;
            end
        end
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'd0;
    end else begin
        if (res_valid &&!opn_valid) begin
            res_valid <= 1'd0;
        end
    end
end

endmodule