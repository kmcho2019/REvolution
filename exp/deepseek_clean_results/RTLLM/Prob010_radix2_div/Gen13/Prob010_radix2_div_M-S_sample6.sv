module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [2:0] cnt;
reg start_div;
reg [7:0] div_reg;
reg [7:0] divisor_reg;
reg [16:0] sr; // {remainder[7:0], quotient[7:0], 1'b0}
reg sign_reg;
reg dividend_sign;
reg divisor_sign;
wire div_by_zero = (divisor_reg == 0);

// Absolute value calculation
wire [7:0] abs_dividend = (sign_reg & dividend_sign) ? -div_reg : div_reg;
wire [7:0] abs_divisor = (sign_reg & divisor_sign) ? -divisor_reg : divisor_reg;

// Division control
always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt <= 0;
        start_div <= 0;
        res_valid <= 0;
        result <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Start new division
            div_reg <= dividend;
            divisor_reg <= divisor;
            sign_reg <= sign;
            dividend_sign <= dividend[7];
            divisor_sign <= divisor[7];
            sr <= {8'b0, abs_dividend, 1'b0};
            cnt <= 0;
            start_div <= 1;
            res_valid <= 0;
        end else if (start_div) begin
            // Division steps
            if (cnt == 7) begin
                // Final step
                start_div <= 0;
                res_valid <= 1;
                
                // Handle result with sign correction
                if (div_by_zero) begin
                    result <= 16'hFFFF; // Error code
                end else begin
                    result <= {
                        sign_reg & dividend_sign ? -sr[16:9] : sr[16:9], // remainder
                        (sign_reg & (dividend_sign ^ divisor_sign)) ? -sr[8:1] : sr[8:1] // quotient
                    };
                end
            end else begin
                // Normal division step
                cnt <= cnt + 1;
                if (sr[16:9] >= abs_divisor) begin
                    sr <= {sr[16:9] - abs_divisor, sr[8:1], 1'b1};
                end else begin
                    sr <= {sr[16:9], sr[8:1], 1'b0};
                end
            end
        end else begin
            res_valid <= 0;
        end
    end
end

endmodule