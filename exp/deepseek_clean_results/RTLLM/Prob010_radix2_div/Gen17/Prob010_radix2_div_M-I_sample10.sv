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
reg [7:0] abs_divisor;
reg [7:0] pos_dividend;
reg result_sign;
reg [2:0] cnt;  // Counts 0-7 for 8 iterations
reg [15:0] div_reg;  // {remainder[15:8], quotient[7:0]}

// Combinational signals
wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] effective_divisor = (sign & divisor[7]) ? -divisor : divisor;
wire div_by_zero = (divisor == 8'b0);

// Subtraction pipeline
reg [8:0] sub_result;
wire [8:0] sub_value = {abs_divisor, 1'b0};
wire [8:0] remainder_ext = {div_reg[15:8], 1'b0};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        result <= 16'b0;
        cnt <= 3'b0;
        div_reg <= 16'b0;
        abs_divisor <= 8'b0;
        pos_dividend <= 8'b0;
        result_sign <= 1'b0;
    end else begin
        // Clear valid flag when result is consumed
        if (res_valid && !opn_valid) begin
            res_valid <= 1'b0;
        end
        
        // Start new operation
        if (opn_valid && !res_valid && cnt == 0) begin
            // Handle sign and absolute values
            abs_divisor <= effective_divisor;
            pos_dividend <= abs_dividend;
            result_sign <= sign & (dividend[7] ^ divisor[7]);
            
            if (div_by_zero) begin
                // Divide by zero: remainder = dividend, quotient = max
                result <= {dividend, 8'hFF};
                res_valid <= 1'b1;
            end else begin
                // Initialize division registers
                div_reg <= {8'b0, abs_dividend};
                cnt <= 3'b1;  // Start counting
            end
        end else if (cnt != 0) begin
            // Pre-calculate subtraction result
            sub_result <= remainder_ext - sub_value;
            
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
                cnt <= 3'b0;
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