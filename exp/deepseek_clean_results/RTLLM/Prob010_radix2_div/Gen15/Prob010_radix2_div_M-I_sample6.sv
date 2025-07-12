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
localparam IDLE = 1'b0;
localparam OPERATE = 1'b1;

reg state;
reg [3:0] cnt;
reg [15:0] SR;  // {remainder, quotient}

// Operation registers
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] divisor_abs;
reg quotient_sign;
reg special_case;

// Division signals
wire [8:0] add_result = {SR[15:8], 1'b0} + {1'b0, divisor_abs};
wire [8:0] sub_result = {SR[15:8], 1'b0} + {1'b0, ~divisor_abs + 1'b1};
wire [15:0] next_SR = SR[15] ? 
    {add_result[7:0], SR[7:1], 1'b0} : 
    {sub_result[7:0], SR[7:1], 1'b1};

// Special case detection
wire is_div_by_zero = (divisor_reg == 0);
wire is_div_by_one = (divisor_abs == 1);
wire is_dividend_zero = (dividend_reg == 0);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        SR <= 0;
        res_valid <= 0;
        result <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        divisor_abs <= 0;
        quotient_sign <= 0;
        special_case <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    // Register inputs
                    dividend_reg <= dividend;
                    divisor_reg <= divisor;
                    
                    // Calculate absolute values and sign
                    if (sign) begin
                        dividend_reg <= dividend[7] ? -dividend : dividend;
                        divisor_abs <= divisor[7] ? -divisor : divisor;
                        quotient_sign <= dividend[7] ^ divisor[7];
                    end else begin
                        dividend_reg <= dividend;
                        divisor_abs <= divisor;
                        quotient_sign <= 0;
                    end
                    
                    // Check for special cases
                    if (is_div_by_zero) begin
                        result <= {dividend, 8'hFF}; // Divide by zero result
                        res_valid <= 1;
                    end 
                    else if (is_div_by_one) begin
                        result <= {8'b0, dividend_reg};
                        if (quotient_sign) result[7:0] <= -dividend_reg;
                        res_valid <= 1;
                    end
                    else if (is_dividend_zero) begin
                        result <= 0;
                        res_valid <= 1;
                    end
                    else begin
                        // Initialize division
                        SR <= {8'b0, dividend_reg};
                        cnt <= 0;
                        state <= OPERATE;
                    end
                end
            end
            
            OPERATE: begin
                if (cnt == 8) begin
                    // Final remainder adjustment if needed
                    if (SR[15]) begin
                        SR[15:8] <= SR[15:8] + divisor_abs;
                    end
                    
                    // Prepare result with sign correction
                    result[15:8] <= sign & dividend_reg[7] ? -SR[15:8] : SR[15:8];
                    result[7:0] <= quotient_sign ? -SR[7:0] : SR[7:0];
                    res_valid <= 1;
                    state <= IDLE;
                end else begin
                    SR <= next_SR;
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

endmodule