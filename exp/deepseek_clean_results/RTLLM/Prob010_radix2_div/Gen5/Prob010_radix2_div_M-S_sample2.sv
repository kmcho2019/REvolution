module radix2_div (
    input wire clk,
    input wire rst,
    input wire sign,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    input wire opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [7:0] dividend_reg, divisor_reg;
reg [15:0] acc;  // {remainder, quotient}
reg [3:0] cnt;
reg q_sign, r_sign;
reg calculating;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        calculating <= 0;
    end else begin
        if (opn_valid && !calculating && !res_valid) begin
            // Capture inputs and initialize
            q_sign <= sign & (dividend[7] ^ divisor[7]);
            r_sign <= sign & dividend[7];
            dividend_reg <= (sign & dividend[7]) ? -dividend : dividend;
            divisor_reg <= (sign & divisor[7]) ? -divisor : divisor;
            
            acc <= {8'b0, dividend_reg};
            cnt <= 0;
            calculating <= 1;
            res_valid <= 0;
        end else if (calculating) begin
            // Division step
            if (acc[15:8] >= divisor_reg) begin
                acc <= {acc[15:8] - divisor_reg, acc[7:0], 1'b1};
            end else begin
                acc <= {acc[15:0], 1'b0};
            end
            
            cnt <= cnt + 1;
            
            if (cnt == 7) begin
                // Finalize result
                if (sign) begin
                    result[7:0] <= q_sign ? -acc[7:0] : acc[7:0];
                    result[15:8] <= r_sign ? -acc[15:8] : acc[15:8];
                end else begin
                    result <= acc;
                end
                
                res_valid <= 1;
                calculating <= 0;
            end
        end else if (res_valid) begin
            // Hold result until next operation
            res_valid <= 0;
        end
    end
end

endmodule