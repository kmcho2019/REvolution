module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [7:0] SR;  // Shift Register
reg [7:0] NEG_DIVISOR;  // Negated absolute value of divisor
reg [2:0] cnt;  // Counter
reg start_cnt;  // Start counter signal
reg [7:0] abs_dividend;  // Absolute value of dividend
reg [7:0] abs_divisor;  // Absolute value of divisor
reg dividend_saved;  // Saved dividend
reg divisor_saved;  // Saved divisor
reg quotient;  // Quotient
reg remainder;  // Remainder
reg res_valid_reg;  // Result valid register

always @(posedge clk) begin
    if (rst) begin
        SR <= 8'b0;
        NEG_DIVISOR <= 8'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
        res_valid_reg <= 1'b0;
    end else if (opn_valid && !res_valid_reg) begin
        // Save inputs
        abs_dividend <= (sign) ? (~dividend + 1) : dividend;
        abs_divisor <= (sign) ? (~divisor + 1) : divisor;
        dividend_saved <= dividend;
        divisor_saved <= divisor;
        
        // Initialize shift register and negated divisor
        SR <= {1'b0, abs_dividend};
        NEG_DIVISOR <= ~abs_divisor + 1;
        
        // Initialize counter and start signal
        cnt <= 1;
        start_cnt <= 1'b1;
        
        res_valid_reg <= 1'b0;
    end else if (start_cnt) begin
        // Check if division is complete
        if (cnt == 8) begin
            // Update result
            result <= {abs_dividend, SR[7:0]};
            res_valid_reg <= 1'b1;
            start_cnt <= 1'b0;
            cnt <= 3'b0;
        end else begin
            // Perform subtraction and update shift register
            if (SR[7:0] >= abs_divisor) begin
                SR <= {SR[7:0] - abs_divisor, 1'b1};
            end else begin
                SR <= {SR[7:0], 1'b0};
            end
            
            // Increment counter
            cnt <= cnt + 1;
        end
    end else if (res_valid_reg && !opn_valid) begin
        res_valid_reg <= 1'b0;
    end
end

assign res_valid = res_valid_reg;

endmodule