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
localparam ST_INPUT = 2'b00;
localparam ST_CALC = 2'b01;
localparam ST_OUTPUT = 2'b10;

reg [1:0] stage;
reg [3:0] cnt;
reg signed [8:0] partial_remainder;
reg [7:0] partial_quotient;
reg [7:0] saved_divisor;
reg quotient_sign;
reg special_case;
reg divide_by_zero;

// Early termination signals
wire is_divisor_zero = (divisor == 8'b0);
wire is_divisor_one = (divisor == 8'b1);
wire is_dividend_zero = (dividend == 8'b0);
wire early_terminate = is_divisor_zero | is_divisor_one | is_dividend_zero;

// Absolute value calculation
wire [7:0] abs_dividend = sign & dividend[7] ? -dividend : dividend;
wire [7:0] abs_divisor = sign & divisor[7] ? -divisor : divisor;
wire [7:0] neg_divisor = -abs_divisor;

// Main pipeline control
always @(posedge clk or posedge rst) begin
    if (rst) begin
        stage <= ST_INPUT;
        res_valid <= 0;
        result <= 16'b0;
        cnt <= 4'b0;
        partial_remainder <= 9'b0;
        partial_quotient <= 8'b0;
        quotient_sign <= 1'b0;
        special_case <= 1'b0;
        divide_by_zero <= 1'b0;
    end else begin
        case (stage)
            ST_INPUT: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    divide_by_zero <= is_divisor_zero;
                    quotient_sign <= sign & (dividend[7] ^ divisor[7]);
                    special_case <= early_terminate;
                    
                    if (early_terminate) begin
                        // Handle special cases immediately
                        partial_quotient <= is_divisor_zero ? 8'hFF : 
                                          is_divisor_one ? abs_dividend : 8'b0;
                        partial_remainder <= is_divisor_zero ? {1'b0, dividend} : 9'b0;
                        stage <= ST_OUTPUT;
                    end else begin
                        // Initialize normal division
                        partial_remainder <= {1'b0, abs_dividend};
                        partial_quotient <= 8'b0;
                        saved_divisor <= abs_divisor;
                        cnt <= 4'b0;
                        stage <= ST_CALC;
                    end
                end
            end
            
            ST_CALC: begin
                if (cnt == 8) begin
                    stage <= ST_OUTPUT;
                end else begin
                    // Radix-2 division step
                    if (partial_remainder[8] == 1'b0) begin
                        // Subtract divisor if remainder is positive
                        partial_remainder <= {partial_remainder[7:0], partial_quotient[7]} + 
                                           {neg_divisor, 1'b0};
                        partial_quotient <= {partial_quotient[6:0], 1'b1};
                    end else begin
                        // Shift only if remainder is negative
                        partial_remainder <= {partial_remainder[7:0], partial_quotient[7]};
                        partial_quotient <= {partial_quotient[6:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end
            
            ST_OUTPUT: begin
                // Format final result with sign handling
                if (divide_by_zero) begin
                    result <= {dividend, 8'hFF};
                end else if (special_case) begin
                    result <= {8'b0, partial_quotient};
                end else begin
                    result <= {
                        sign & dividend[7] ? -partial_remainder[8:1] : partial_remainder[8:1],
                        quotient_sign ? -partial_quotient : partial_quotient
                    };
                end
                res_valid <= 1;
                stage <= ST_INPUT;
            end
        endcase
    end
end

endmodule