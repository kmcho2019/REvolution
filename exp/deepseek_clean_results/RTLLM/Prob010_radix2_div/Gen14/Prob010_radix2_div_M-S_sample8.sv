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

reg [15:0] SR;  // {remainder, quotient}
reg [2:0] cnt;

wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_abs = (sign & divisor[7]) ? -divisor : divisor;
wire quotient_sign = sign & (dividend[7] ^ divisor[7]);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 16'b0;
        res_valid <= 1'b0;
        result <= 16'b0;
        cnt <= 3'b0;
    end else begin
        res_valid <= 1'b0;
        
        if (opn_valid && !res_valid && !cnt) begin
            if (divisor == 8'b0) begin
                result <= {dividend, 8'hFF};
                res_valid <= 1'b1;
            end else begin
                SR <= {7'b0, dividend_abs, 1'b0};
                cnt <= 3'd1;
            end
        end else if (|cnt) begin
            if (cnt[2]) begin  // cnt == 4 (100)
                result <= {
                    (sign & dividend[7]) ? -SR[15:8] : SR[15:8],
                    quotient_sign ? -SR[7:0] : SR[7:0]
                };
                res_valid <= 1'b1;
                cnt <= 3'b0;
            end else begin
                SR <= (SR[15:8] >= divisor_abs) ? 
                      {SR[15:8] - divisor_abs, SR[7:0], 1'b1} : 
                      {SR[14:0], 1'b0};
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule