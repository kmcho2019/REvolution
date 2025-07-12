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

// State machine definitions
localparam IDLE  = 2'b00;
localparam COMPUTE = 2'b01;
localparam DONE  = 2'b10;

reg [1:0] state, next_state;
reg [3:0] iteration;

// Data registers
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] remainder;
reg [7:0] quotient;
reg sign_reg;

// Sign handling
reg dividend_sign;
reg divisor_sign;

// Absolute value calculations
wire [7:0] abs_dividend = (sign_reg & dividend_sign) ? -dividend_reg : dividend_reg;
wire [7:0] abs_divisor = (sign_reg & divisor_sign) ? -divisor_reg : divisor_reg;

// Special case detection
wire divisor_is_zero = (divisor_reg == 8'b0);
wire divisor_is_one = (divisor_reg == 8'b1);

// Division step signals
wire [7:0] remainder_minus_divisor = remainder - abs_divisor;
wire [7:0] remainder_plus_divisor = remainder + abs_divisor;
wire remainder_negative = remainder[7];

// Next remainder and quotient
wire [7:0] next_remainder = remainder_negative ? remainder_plus_divisor : remainder_minus_divisor;
wire [7:0] next_quotient = {quotient[6:0], ~remainder_negative};

// State machine transition logic
always @(*) begin
    case (state)
        IDLE: next_state = (opn_valid && !divisor_is_zero) ? COMPUTE : IDLE;
        COMPUTE: next_state = (iteration == 4'd7) ? DONE : COMPUTE;
        DONE: next_state = (!opn_valid) ? IDLE : DONE;
        default: next_state = IDLE;
    endcase
end

// State machine sequential logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        iteration <= 4'b0;
        res_valid <= 1'b0;
        result <= 16'b0;
    end else begin
        state <= next_state;
        
        case (state)
            IDLE: begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    dividend_reg <= dividend;
                    divisor_reg <= divisor;
                    sign_reg <= sign;
                    dividend_sign <= dividend[7];
                    divisor_sign <= divisor[7];
                    
                    if (divisor_is_zero) begin
                        result <= 16'hFFFF;
                        res_valid <= 1'b1;
                    end else if (divisor_is_one) begin
                        result <= {8'b0, (sign & dividend[7]) ? -dividend : dividend};
                        res_valid <= 1'b1;
                    end else begin
                        remainder <= 8'b0;
                        quotient <= (sign & dividend[7]) ? -dividend : dividend;
                        iteration <= 4'b0;
                    end
                end
            end
            
            COMPUTE: begin
                remainder <= next_remainder;
                quotient <= next_quotient;
                iteration <= iteration + 1;
            end
            
            DONE: begin
                // Final remainder adjustment
                if (remainder[7]) begin
                    remainder <= remainder + abs_divisor;
                end
                
                // Apply sign correction if signed operation
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

endmodule