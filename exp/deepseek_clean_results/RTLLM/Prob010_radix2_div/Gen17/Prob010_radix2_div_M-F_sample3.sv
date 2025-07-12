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

reg [2:0] cnt;
reg [15:0] shift_reg;  // [remainder|quotient]
reg quotient_sign;
reg divide_by_zero;
reg [7:0] divisor_abs;
reg [7:0] dividend_abs;
reg processing;

// Absolute value calculation
wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] abs_divisor = (sign & divisor[7]) ? -divisor : divisor;

// Subtraction result
wire [8:0] sub_result = {1'b0, shift_reg[15:8]} + {1'b0, ~divisor_abs + 1'b1};
wire sub_positive = ~sub_result[8];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        shift_reg <= 0;
        quotient_sign <= 0;
        divide_by_zero <= 0;
        divisor_abs <= 0;
        dividend_abs <= 0;
        processing <= 0;
    end else begin
        if (opn_valid && !processing && !res_valid) begin
            // Start new operation
            divide_by_zero <= (divisor == 0);
            quotient_sign <= sign & (dividend[7] ^ divisor[7]);
            divisor_abs <= abs_divisor;
            dividend_abs <= abs_dividend;
            
            if (divisor == 0) begin
                result <= {dividend, 8'hFF};  // Divide by zero result
                res_valid <= 1;
            end else begin
                shift_reg <= {8'b0, abs_dividend};
                cnt <= 0;
                processing <= 1;
                res_valid <= 0;
            end
        end else if (processing) begin
            // Division iteration
            if (cnt == 3'd7) begin
                // Final iteration
                if (sub_positive) begin
                    shift_reg <= {sub_result[7:0], shift_reg[7:1], 1'b1};
                end else begin
                    // Restore remainder
                    shift_reg[15:8] <= shift_reg[15:8] + divisor_abs;
                end
                
                // Apply signs if needed
                result[15:8] <= (sign & dividend[7]) ? -shift_reg[15:8] : shift_reg[15:8];
                result[7:0] <= quotient_sign ? -shift_reg[7:0] : shift_reg[7:0];
                res_valid <= 1;
                processing <= 0;
            end else begin
                // Normal iteration
                if (sub_positive) begin
                    shift_reg <= {sub_result[7:0], shift_reg[7:1], 1'b1};
                end else begin
                    shift_reg <= {shift_reg[14:0], 1'b0};
                end
                cnt <= cnt + 1;
            end
        end else if (res_valid && !opn_valid) begin
            // Clear valid when operation is complete
            res_valid <= 0;
        end
    end
end

endmodule