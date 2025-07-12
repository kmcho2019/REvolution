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
reg [15:0] div_reg;  // {remainder, quotient}
reg [7:0] abs_divisor;
reg result_sign;
reg calculating;

// Absolute values and sign calculation
wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] abs_divisor_w = (sign & divisor[7]) ? -divisor : divisor;
wire div_by_zero = (divisor == 8'b0);

// Subtraction logic
wire [8:0] sub_result = {div_reg[15:8], 1'b0} - {abs_divisor, 1'b0};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        result <= 16'b0;
        cnt <= 0;
        calculating <= 0;
    end else begin
        if (calculating) begin
            if (cnt == 8) begin
                // Final adjustment for negative remainder
                if (div_reg[15]) div_reg[15:8] <= div_reg[15:8] + abs_divisor;
                
                // Apply sign to final result
                result <= {
                    (sign & dividend[7]) ? -div_reg[15:8] : div_reg[15:8],
                    result_sign ? -div_reg[7:0] : div_reg[7:0]
                };
                res_valid <= 1'b1;
                calculating <= 0;
            end else begin
                // Regular division step
                div_reg <= sub_result[8] ? 
                    {div_reg[15:8], div_reg[7:1], 1'b0} :  // Negative result
                    {sub_result[7:0], div_reg[7:1], 1'b1};  // Positive result
                cnt <= cnt + 1;
            end
        end else if (opn_valid && !res_valid) begin
            // Start new division
            abs_divisor <= abs_divisor_w;
            result_sign <= sign & (dividend[7] ^ divisor[7]);
            
            if (div_by_zero) begin
                result <= {dividend, 8'hFF};
                res_valid <= 1'b1;
            end else begin
                div_reg <= {8'b0, abs_dividend};
                cnt <= 0;
                calculating <= 1;
                res_valid <= 0;
            end
        end else if (!opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule