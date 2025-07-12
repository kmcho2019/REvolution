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

reg [15:0] SR;       // [remainder|quotient]
reg [7:0] divisor_neg;
reg [3:0] cnt;
reg quotient_sign;
reg calculating;

wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_abs = (sign & divisor[7]) ? -divisor : divisor;
wire [8:0] sub_result = {1'b0, SR[15:8]} + {1'b0, divisor_neg};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        calculating <= 0;
        cnt <= 0;
    end else begin
        if (calculating) begin
            if (cnt == 8) begin
                // Finalize result
                result <= {
                    (sign & dividend[7]) ? -SR[15:8] : SR[15:8],
                    quotient_sign ? -SR[7:0] : SR[7:0]
                };
                res_valid <= 1;
                calculating <= 0;
            end else begin
                // Division step
                if (sub_result[8]) begin  // if remainder >= divisor
                    SR <= {sub_result[7:0], SR[7:1], 1'b1};
                end else begin
                    SR <= {SR[14:0], 1'b0};
                end
                cnt <= cnt + 1;
            end
        end else if (opn_valid && !res_valid) begin
            if (divisor == 0) begin
                // Handle divide by zero
                result <= {dividend, 8'hFF};
                res_valid <= 1;
            end else begin
                // Initialize division
                SR <= {8'b0, dividend_abs};
                divisor_neg <= -divisor_abs;
                quotient_sign <= sign & (dividend[7] ^ divisor[7]);
                cnt <= 0;
                calculating <= 1;
                res_valid <= 0;
            end
        end else if (res_valid && opn_valid) begin
            res_valid <= 0;  // Ready for next operation
        end
    end
end

endmodule