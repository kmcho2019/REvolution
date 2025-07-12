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

// Pipeline stage registers
reg [1:0] stage;
localparam STAGE_INPUT = 0;
localparam STAGE_CALC = 1;
localparam STAGE_OUTPUT = 2;

// Operation registers
reg [7:0] dividend_abs;
reg [7:0] divisor_abs;
reg dividend_sign;
reg divisor_sign;
reg [7:0] calc_divisor;
reg [15:0] shift_reg;  // {remainder, quotient}
reg [3:0] iteration;
reg early_term;

// Combinational signals
wire [8:0] sub_result = {shift_reg[15:8], 1'b0} + {1'b0, ~calc_divisor + 1'b1};
wire sub_positive = ~sub_result[8];
wire [15:0] next_shift = sub_positive ? 
    {sub_result[7:0], shift_reg[7:0], 1'b1} : 
    {shift_reg[14:0], 1'b0};
wire remainder_zero = (shift_reg[15:8] == 0);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        stage <= STAGE_INPUT;
        res_valid <= 0;
        result <= 0;
        early_term <= 0;
    end else begin
        case (stage)
            STAGE_INPUT: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Handle special case: divide by zero
                    if (divisor == 0) begin
                        result <= {8'hFF, 8'hFF};  // Max value as error indicator
                        res_valid <= 1;
                        stage <= STAGE_INPUT;
                    end else begin
                        // Store absolute values and signs
                        dividend_abs <= sign & dividend[7] ? -dividend : dividend;
                        divisor_abs <= sign & divisor[7] ? -divisor : divisor;
                        dividend_sign <= sign & dividend[7];
                        divisor_sign <= sign & divisor[7];
                        
                        // Initialize calculation
                        shift_reg <= {8'b0, dividend_abs};
                        calc_divisor <= sign & divisor[7] ? -divisor : divisor;
                        iteration <= 0;
                        early_term <= 0;
                        stage <= STAGE_CALC;
                    end
                end
            end
            
            STAGE_CALC: begin
                if (early_term || iteration == 7) begin
                    // Final adjustment for non-restoring division
                    if (shift_reg[15]) begin
                        shift_reg[15:8] <= shift_reg[15:8] + calc_divisor;
                    end
                    stage <= STAGE_OUTPUT;
                end else begin
                    // Normal iteration
                    shift_reg <= next_shift;
                    iteration <= iteration + 1;
                    early_term <= remainder_zero;
                end
            end
            
            STAGE_OUTPUT: begin
                // Apply sign correction
                result <= {
                    dividend_sign ? -shift_reg[15:8] : shift_reg[15:8],  // remainder
                    (dividend_sign ^ divisor_sign) ? -shift_reg[7:0] : shift_reg[7:0]  // quotient
                };
                res_valid <= 1;
                stage <= STAGE_INPUT;
            end
        endcase
    end
end

endmodule