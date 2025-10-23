module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result  // {remainder[7:0], quotient[7:0]}
);

reg [7:0] remainder;
reg [7:0] quotient;
reg [7:0] divisor_abs;
reg [7:0] divisor_neg;
reg [3:0] cnt;
reg quotient_sign;
reg error_flag;
reg calculating;

wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [8:0] sub_result = {1'b0, remainder} + {1'b0, divisor_neg};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        calculating <= 0;
        cnt <= 0;
        error_flag <= 0;
    end else begin
        if (calculating) begin
            if (cnt == 8 || (remainder == 0 && cnt > 0)) begin
                // Finalize result (early termination if remainder becomes zero)
                result <= {
                    (sign & dividend[7]) ? -remainder : remainder,
                    (quotient_sign && |quotient) ? -quotient : quotient
                };
                res_valid <= 1;
                calculating <= 0;
            end else begin
                // Division step
                if (sub_result[8]) begin  // if remainder >= divisor
                    {remainder, quotient} <= {sub_result[7:0], quotient[6:0], 1'b1};
                end else begin
                    {remainder, quotient} <= {remainder[6:0], quotient, 1'b0};
                end
                cnt <= cnt + 1;
            end
        end else if (opn_valid && !res_valid) begin
            if (divisor == 0) begin
                // Handle divide by zero
                result <= {dividend, 8'hFF};
                error_flag <= 1;
                res_valid <= 1;
            end else if (dividend == 0) begin
                // Early termination for zero dividend
                result <= 0;
                res_valid <= 1;
            end else begin
                // Initialize division
                remainder <= dividend_abs;
                quotient <= 0;
                divisor_abs <= (sign & divisor[7]) ? -divisor : divisor;
                divisor_neg <= -(sign & divisor[7]) ? -divisor : divisor;
                quotient_sign <= sign & (dividend[7] ^ divisor[7]);
                cnt <= 0;
                calculating <= 1;
                error_flag <= 0;
                res_valid <= 0;
            end
        end else if (res_valid && opn_valid) begin
            res_valid <= 0;  // Ready for next operation
        end
    end
end

endmodule