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
reg [15:0] working_reg; // {remainder, quotient}
reg [7:0] divisor_reg;
reg sign_reg;
reg calculating;

wire [7:0] dividend_abs = sign & dividend[7] ? -dividend : dividend;
wire [7:0] divisor_abs = sign & divisor[7] ? -divisor : divisor;
wire [8:0] sub_result = {working_reg[15:8], working_reg[7]} + {1'b0, ~divisor_reg} + 9'b1;
wire sub_negative = sub_result[8];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 16'b0;
        cnt <= 0;
        calculating <= 0;
    end else begin
        if (opn_valid && !calculating) begin
            // Start new division
            working_reg <= {8'b0, dividend_abs};
            divisor_reg <= divisor_abs;
            sign_reg <= sign;
            cnt <= 0;
            calculating <= (divisor != 0); // Skip if divisor is zero
            res_valid <= (divisor == 0);  // Immediate result for div by zero
            result <= (divisor == 0) ? {8'hFF, 8'hFF} : 16'b0;
        end else if (calculating) begin
            if (cnt == 8) begin
                // Finalize result with sign correction
                if (sign_reg) begin
                    working_reg[15:8] <= (dividend[7]) ? -working_reg[15:8] : working_reg[15:8];
                    working_reg[7:0] <= (dividend[7] ^ divisor[7]) ? -working_reg[7:0] : working_reg[7:0];
                end
                result <= working_reg;
                res_valid <= 1;
                calculating <= 0;
            end else begin
                // Perform one division step
                working_reg <= sub_negative ?
                    {working_reg[14:0], 1'b0} :
                    {sub_result[7:0], working_reg[6:0], 1'b1};
                cnt <= cnt + 1;
            end
        end
        
        // Clear valid flag when new operation starts
        if (opn_valid && res_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule