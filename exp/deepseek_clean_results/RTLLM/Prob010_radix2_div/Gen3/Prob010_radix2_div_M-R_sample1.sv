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
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] remainder;
reg [7:0] quotient;
reg [3:0] cnt;
reg calculating;
reg signed_op;
reg div_by_zero;

// Absolute value calculations
wire [7:0] dividend_abs = signed_op & dividend_reg[7] ? -dividend_reg : dividend_reg;
wire [7:0] divisor_abs = signed_op & divisor_reg[7] ? -divisor_reg : divisor_reg;

// Division logic signals
wire [8:0] sub_result = {remainder, quotient[7]} + {1'b0, ~divisor_abs} + 9'b1;
wire sub_negative = sub_result[8];
wire calculation_done = (cnt == 8);

// Input processing
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 8'b0;
        divisor_reg <= 8'b0;
        signed_op <= 1'b0;
        div_by_zero <= 1'b0;
        calculating <= 1'b0;
    end else if (opn_valid && !calculating && !res_valid) begin
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        signed_op <= sign;
        div_by_zero <= (divisor == 8'b0);
        calculating <= 1'b1;
    end else if (calculation_done) begin
        calculating <= 1'b0;
    end
end

// Division calculation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        remainder <= 8'b0;
        quotient <= 8'b0;
        cnt <= 4'b0;
        res_valid <= 1'b0;
        result <= 16'b0;
    end else begin
        if (calculating && !calculation_done) begin
            // Perform one division step
            remainder <= sub_negative ? 
                {remainder[6:0], quotient[7]} : 
                sub_result[7:0];
            quotient <= sub_negative ? 
                {quotient[6:0], 1'b0} : 
                {quotient[6:0], 1'b1};
            cnt <= cnt + 1;
        end else if (calculation_done) begin
            // Finalize result with sign correction if needed
            if (div_by_zero) begin
                result <= {8'hFF, 8'hFF}; // Special encoding for div by zero
            end else if (signed_op) begin
                remainder <= dividend_reg[7] ? -remainder : remainder;
                quotient <= (dividend_reg[7] ^ divisor_reg[7]) ? -quotient : quotient;
                result <= {remainder, quotient};
            end else begin
                result <= {remainder, quotient};
            end
            res_valid <= 1'b1;
            cnt <= 4'b0;
        end else if (opn_valid && res_valid) begin
            res_valid <= 1'b0;
        end
        
        // Initialize calculation
        if (opn_valid && !calculating && !res_valid) begin
            if (dividend == 8'b0) begin
                // Early termination for zero dividend
                result <= 16'b0;
                res_valid <= 1'b1;
            end else if (!div_by_zero) begin
                remainder <= 8'b0;
                quotient <= dividend_abs;
                cnt <= 4'b0;
            end
        end
    end
end

endmodule