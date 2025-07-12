module radix2_div (
    input wire clk,
    input wire rst,
    input wire sign,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    input wire opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// State definitions
localparam IDLE  = 2'b00;
localparam COMPUTE = 2'b01;
localparam DONE  = 2'b10;

reg [1:0] state, next_state;

// Pipeline registers
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg sign_reg;

// Division algorithm registers
reg [7:0] remainder;
reg [7:0] quotient;
reg [3:0] iteration;

// Sign tracking
reg dividend_sign;
reg divisor_sign;

// Special case detection
wire divisor_is_zero = (divisor == 8'b0);
wire divisor_is_one = (divisor == 8'b1);
wire divisor_is_pow2 = (divisor & (divisor - 1)) == 0;
wire [4:0] pow2_shift;

// Absolute values
wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] abs_divisor = (sign & divisor[7]) ? -divisor : divisor;

// Find power-of-two shift amount
assign pow2_shift = 
    (divisor_reg == 8'h01) ? 0 :
    (divisor_reg == 8'h02) ? 1 :
    (divisor_reg == 8'h04) ? 2 :
    (divisor_reg == 8'h08) ? 3 :
    (divisor_reg == 8'h10) ? 4 :
    (divisor_reg == 8'h20) ? 5 :
    (divisor_reg == 8'h40) ? 6 :
    (divisor_reg == 8'h80) ? 7 : 0;

// State machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        dividend_reg <= 8'b0;
        divisor_reg <= 8'b0;
        sign_reg <= 1'b0;
        remainder <= 8'b0;
        quotient <= 8'b0;
        iteration <= 4'b0;
        res_valid <= 1'b0;
        result <= 16'b0;
    end else begin
        state <= next_state;
        
        case (state)
            IDLE: begin
                if (opn_valid) begin
                    dividend_reg <= dividend;
                    divisor_reg <= divisor;
                    sign_reg <= sign;
                    
                    // Store signs for signed operations
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    
                    // Initialize division registers
                    remainder <= 8'b0;
                    quotient <= abs_dividend;
                    iteration <= 4'b0;
                end
                res_valid <= 1'b0;
            end
            
            COMPUTE: begin
                if (divisor_is_pow2 && !sign_reg) begin
                    // Fast path for power-of-two divisors
                    quotient <= abs_dividend >> pow2_shift;
                    remainder <= abs_dividend & (abs_divisor - 1);
                    next_state <= DONE;
                end else begin
                    // Radix-2 division step
                    {remainder, quotient} <= {remainder[6:0], quotient, 1'b0};
                    
                    if (!remainder[7]) begin
                        remainder <= remainder - abs_divisor;
                        quotient[0] <= 1'b1;
                    end else begin
                        remainder <= remainder + abs_divisor;
                        quotient[0] <= 1'b0;
                    end
                    
                    iteration <= iteration + 1;
                end
            end
            
            DONE: begin
                // Final remainder adjustment
                if (remainder[7]) begin
                    remainder <= remainder + abs_divisor;
                end
                
                // Sign correction for signed operations
                if (sign_reg) begin
                    quotient <= (dividend_sign ^ divisor_sign) ? -quotient : quotient;
                    remainder <= dividend_sign ? -remainder : remainder;
                end
                
                result <= {remainder, quotient};
                res_valid <= 1'b1;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: next_state = (opn_valid && !divisor_is_zero && !divisor_is_one) ? COMPUTE : 
                          (opn_valid && (divisor_is_zero || divisor_is_one)) ? DONE : IDLE;
        COMPUTE: next_state = (iteration == 4'd7 || (divisor_is_pow2 && !sign_reg)) ? DONE : COMPUTE;
        DONE: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Special case handling
always @(posedge clk) begin
    if (state == IDLE && opn_valid) begin
        if (divisor_is_zero) begin
            result <= 16'hFFFF;
            res_valid <= 1'b1;
        end else if (divisor_is_one) begin
            result <= {8'b0, abs_dividend};
            res_valid <= 1'b1;
        end
    end
end

endmodule