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

reg [2:0] cnt;       // Iteration counter (0-7)
reg busy;            // Division in progress
reg [15:0] div_reg;  // {remainder, quotient}
reg result_sign;     // Final result sign

// Division iteration logic
wire [7:0] remainder_msb = div_reg[15:8];
wire [7:0] next_remainder = {remainder_msb[6:0], div_reg[7]};
wire [8:0] sub_result = {next_remainder, 1'b0} - {divisor, 1'b0};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        result <= 16'b0;
        cnt <= 3'b0;
        busy <= 1'b0;
    end else begin
        res_valid <= 1'b0;  // Default unless we set it
        
        if (!busy && opn_valid && !res_valid) begin
            // Start new operation
            if (divisor == 8'b0) begin
                // Handle divide by zero
                result <= {dividend, 8'hFF};
                res_valid <= 1'b1;
            end else begin
                // Initialize registers
                div_reg <= {8'b0, sign & dividend[7] ? -dividend : dividend};
                result_sign <= sign & (dividend[7] ^ divisor[7]);
                cnt <= 3'b0;
                busy <= 1'b1;
            end
        end else if (busy) begin
            // Division iteration
            if (cnt == 3'd7) begin
                // Final iteration
                if (div_reg[15]) begin
                    div_reg[15:8] <= div_reg[15:8] + (sign & divisor[7] ? -divisor : divisor);
                end
                
                // Apply final sign if needed
                result <= {
                    sign & dividend[7] ? -div_reg[15:8] : div_reg[15:8],
                    result_sign ? -div_reg[7:0] : div_reg[7:0]
                };
                res_valid <= 1'b1;
                busy <= 1'b0;
            end else begin
                // Regular iteration
                if (sub_result[8] == 0) begin
                    div_reg <= {sub_result[7:0], div_reg[6:0], 1'b1};
                end else begin
                    div_reg <= {div_reg[15:8], div_reg[6:0], 1'b0};
                end
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule