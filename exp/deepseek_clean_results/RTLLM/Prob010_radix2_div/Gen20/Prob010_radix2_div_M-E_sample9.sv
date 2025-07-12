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

// Internal registers
reg [7:0] remainder;
reg [7:0] quotient;
reg [7:0] divisor_reg;
reg [3:0] cnt;
reg running;
reg sign_q, sign_r;
reg zero_divisor;

// Absolute value conversion
wire [7:0] abs_dividend = sign & dividend[7] ? -dividend : dividend;
wire [7:0] abs_divisor = sign & divisor[7] ? -divisor : divisor;

// Sign tracking
wire dividend_sign = sign & dividend[7];
wire divisor_sign = sign & divisor[7];

// Division signals
wire [8:0] sub_result = {remainder, quotient[7]} + {1'b0, ~divisor_reg + 1'b1};
wire sub_positive = ~sub_result[8];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        running <= 0;
        remainder <= 0;
        quotient <= 0;
        divisor_reg <= 0;
        zero_divisor <= 0;
    end else begin
        if (opn_valid && !running) begin
            // Initialize operation
            divisor_reg <= abs_divisor;
            quotient <= abs_dividend;
            remainder <= 0;
            cnt <= 0;
            running <= 1;
            res_valid <= 0;
            zero_divisor <= (divisor == 0);
            sign_q <= dividend_sign ^ divisor_sign;
            sign_r <= dividend_sign;
        end else if (running) begin
            if (zero_divisor) begin
                // Handle division by zero
                result <= {8'hFF, 8'hFF};
                res_valid <= 1;
                running <= 0;
            end else if (cnt == 8) begin
                // Finalize operation with sign correction
                if (sign) begin
                    result[7:0] <= sign_q ? -quotient : quotient;
                    result[15:8] <= sign_r ? -remainder : remainder;
                end else begin
                    result[7:0] <= quotient;
                    result[15:8] <= remainder;
                end
                res_valid <= 1;
                running <= 0;
            end else begin
                // Perform division step
                cnt <= cnt + 1;
                
                if (sub_positive) begin
                    remainder <= sub_result[7:0];
                    quotient <= {quotient[6:0], 1'b1};
                end else begin
                    remainder <= {remainder[6:0], quotient[7]};
                    quotient <= {quotient[6:0], 1'b0};
                end
            end
        end else begin
            res_valid <= 0;
        end
    end
end

endmodule