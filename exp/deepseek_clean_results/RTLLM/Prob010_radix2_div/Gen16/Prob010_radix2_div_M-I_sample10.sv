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

reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg result_sign;
reg [2:0] cnt;  // Reduced from 4 to 3 bits since we only count to 8
reg [15:0] div_reg;  // {remainder, quotient}
reg active;

wire [8:0] sub_value = {abs_divisor, 1'b0};
wire [8:0] remainder_ext = {div_reg[15:8], 1'b0};
wire [8:0] sub_result = remainder_ext - sub_value;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        result <= 16'b0;
        cnt <= 3'b0;
        active <= 1'b0;
        div_reg <= 16'b0;
    end else begin
        // Clear valid flag when result is consumed
        if (res_valid && !opn_valid) begin
            res_valid <= 1'b0;
        end
        
        // Start new operation
        if (opn_valid && !active && !res_valid) begin
            // Handle sign and absolute values
            abs_dividend <= (sign & dividend[7]) ? -dividend : dividend;
            abs_divisor <= (sign & divisor[7]) ? -divisor : divisor;
            result_sign <= sign & (dividend[7] ^ divisor[7]);
            
            if (divisor == 8'b0) begin
                // Divide by zero special case
                result <= {dividend, 8'hFF};
                res_valid <= 1'b1;
            end else begin
                // Initialize division registers
                div_reg <= {8'b0, abs_dividend};
                cnt <= 3'b0;
                active <= 1'b1;
            end
        end else if (active) begin
            // Division iteration
            if (cnt == 3'd7) begin
                // Final iteration - adjust remainder if negative
                if (div_reg[15]) begin
                    div_reg[15:8] <= div_reg[15:8] + abs_divisor;
                end
                
                // Prepare final result with proper signs
                result <= {
                    (sign & dividend[7]) ? -div_reg[15:8] : div_reg[15:8],
                    result_sign ? -div_reg[7:0] : div_reg[7:0]
                };
                res_valid <= 1'b1;
                active <= 1'b0;
            end else begin
                // Regular iteration step
                if (!sub_result[8]) begin  // If subtraction result is positive
                    div_reg <= {sub_result[7:0], div_reg[7:1], 1'b1};
                end else begin
                    div_reg <= {div_reg[15:8], div_reg[7:1], 1'b0};
                end
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule