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

// Pipeline stages
localparam STAGE_INPUT = 2'b00;
localparam STAGE_CALC = 2'b01;
localparam STAGE_OUTPUT = 2'b10;

reg [1:0] stage;
reg [2:0] cnt;
reg [15:0] shift_reg;
reg running;
reg quotient_sign;
reg div_by_zero;
reg simple_case;

// Pipeline registers
reg [7:0] dividend_abs_reg;
reg [7:0] divisor_abs_reg;
reg [7:0] dividend_sign_reg;
reg [7:0] divisor_sign_reg;

// Combinational calculations
wire [7:0] dividend_abs = sign & dividend[7] ? -dividend : dividend;
wire [7:0] divisor_abs = sign & divisor[7] ? -divisor : divisor;
wire [8:0] sub_result = {shift_reg[15:8], 1'b0} + {1'b0, ~divisor_abs_reg + 1'b1};
wire calc_done = (cnt == 3'd7);

// Early termination conditions
wire zero_divisor = (divisor == 0);
wire dividend_less = (dividend_abs < divisor_abs);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        stage <= STAGE_INPUT;
        cnt <= 0;
        shift_reg <= 0;
        result <= 0;
        res_valid <= 0;
        quotient_sign <= 0;
        div_by_zero <= 0;
        simple_case <= 0;
    end else begin
        case (stage)
            STAGE_INPUT: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Register absolute values and signs
                    dividend_abs_reg <= dividend_abs;
                    divisor_abs_reg <= divisor_abs;
                    dividend_sign_reg <= dividend[7];
                    divisor_sign_reg <= divisor[7];
                    
                    // Calculate quotient sign
                    quotient_sign <= sign & (dividend[7] ^ divisor[7]);
                    
                    // Check for special cases
                    div_by_zero <= zero_divisor;
                    simple_case <= dividend_less;
                    
                    // Initialize shift register
                    shift_reg <= {8'b0, dividend_abs};
                    cnt <= 0;
                    
                    // Move to calculation stage
                    stage <= STAGE_CALC;
                end
            end
            
            STAGE_CALC: begin
                if (div_by_zero) begin
                    // Handle division by zero
                    result <= {dividend_abs_reg, 8'hFF};
                    res_valid <= 1;
                    stage <= STAGE_OUTPUT;
                end else if (simple_case) begin
                    // Handle simple case (dividend < divisor)
                    result <= {dividend_abs_reg, 8'b0};
                    res_valid <= 1;
                    stage <= STAGE_OUTPUT;
                end else if (calc_done) begin
                    // Final remainder adjustment
                    if (shift_reg[15]) begin
                        shift_reg[15:8] <= shift_reg[15:8] + divisor_abs_reg;
                    end
                    stage <= STAGE_OUTPUT;
                end else begin
                    // Radix-2 division step
                    shift_reg <= sub_result[8] ? 
                        {sub_result[7:0], shift_reg[7:1], 1'b0} : 
                        {sub_result[7:0], shift_reg[7:1], 1'b1};
                    cnt <= cnt + 1;
                end
            end
            
            STAGE_OUTPUT: begin
                if (!div_by_zero && !simple_case) begin
                    // Format final result with sign correction
                    result <= {
                        sign & dividend_sign_reg ? -shift_reg[15:8] : shift_reg[15:8],
                        quotient_sign ? -shift_reg[7:0] : shift_reg[7:0]
                    };
                end
                res_valid <= 1;
                
                // Return to input stage when operation completes
                if (!opn_valid) begin
                    stage <= STAGE_INPUT;
                end
            end
        endcase
    end
end

endmodule