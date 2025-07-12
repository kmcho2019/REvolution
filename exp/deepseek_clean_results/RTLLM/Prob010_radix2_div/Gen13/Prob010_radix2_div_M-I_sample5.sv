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

// State encoding
reg calc_active;
reg input_ready;

// Operation registers
reg [7:0] dividend_abs;
reg [7:0] divisor_abs;
reg dividend_sign;
reg divisor_sign;
reg [15:0] shift_reg;  // {remainder, quotient}
reg [2:0] iteration;

// Combinational signals
wire [8:0] sub_result = {shift_reg[15:8], 1'b0} + {1'b0, ~divisor_abs + 1'b1};
wire sub_positive = ~sub_result[8];
wire [15:0] next_shift = sub_positive ? 
    {sub_result[7:0], shift_reg[7:0], 1'b1} : 
    {shift_reg[14:0], 1'b0};
wire remainder_zero = (shift_reg[15:8] == 0);
wire calc_done = (iteration == 3'd7) || remainder_zero;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        calc_active <= 0;
        input_ready <= 1;
        res_valid <= 0;
        result <= 0;
    end else begin
        // Default assignments
        res_valid <= 0;
        
        if (input_ready) begin
            if (opn_valid) begin
                // Handle special cases
                if (divisor == 0) begin
                    result <= {8'hFF, 8'hFF};  // Divide by zero
                    res_valid <= 1;
                end else if (dividend == 0) begin
                    result <= 0;  // Zero dividend
                    res_valid <= 1;
                end else begin
                    // Store absolute values and signs
                    dividend_abs <= sign & dividend[7] ? -dividend : dividend;
                    divisor_abs <= sign & divisor[7] ? -divisor : divisor;
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    
                    // Initialize calculation
                    shift_reg <= {8'b0, dividend_abs};
                    iteration <= 0;
                    calc_active <= 1;
                    input_ready <= 0;
                end
            end
        end else if (calc_active) begin
            if (calc_done) begin
                // Final adjustment for non-restoring division
                if (shift_reg[15]) begin
                    shift_reg[15:8] <= shift_reg[15:8] + divisor_abs;
                end
                
                // Apply sign correction
                result <= {
                    dividend_sign ? -shift_reg[15:8] : shift_reg[15:8],  // remainder
                    (dividend_sign ^ divisor_sign) ? -shift_reg[7:0] : shift_reg[7:0]  // quotient
                };
                
                res_valid <= 1;
                calc_active <= 0;
                input_ready <= 1;
            end else begin
                // Normal iteration
                shift_reg <= next_shift;
                iteration <= iteration + 1;
            end
        end
    end
end

endmodule