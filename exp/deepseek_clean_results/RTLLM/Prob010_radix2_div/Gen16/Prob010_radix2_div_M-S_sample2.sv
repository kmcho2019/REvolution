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

reg [3:0] cnt;
reg [15:0] SR;  // {remainder, quotient}

wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_abs = (sign & divisor[7]) ? -divisor : divisor;
wire quotient_sign = sign & (dividend[7] ^ divisor[7]);
wire [8:0] sub_result = {SR[15:8], 1'b0} + {1'b0, ~divisor_abs + 1'b1};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        SR <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            if (divisor == 0) begin
                result <= {dividend, 8'hFF};
                res_valid <= 1;
            end else begin
                SR <= {8'b0, dividend_abs};
                cnt <= 1;
                res_valid <= 0;
            end
        end else if (cnt > 0 && cnt < 9) begin
            if (cnt == 8) begin
                // Final remainder adjustment if needed
                result <= {
                    (sign & dividend[7]) ? -(SR[15] ? SR[15:8] + divisor_abs : SR[15:8]) : 
                                           (SR[15] ? SR[15:8] + divisor_abs : SR[15:8]),
                    quotient_sign ? -SR[7:0] : SR[7:0]
                };
                res_valid <= 1;
                cnt <= 0;
            end else begin
                // Shift and subtract
                SR <= sub_result[8] ? 
                    {sub_result[7:0], SR[7:1], 1'b0} : 
                    {sub_result[7:0], SR[7:1], 1'b1};
                cnt <= cnt + 1;
            end
        end else if (res_valid && !opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule