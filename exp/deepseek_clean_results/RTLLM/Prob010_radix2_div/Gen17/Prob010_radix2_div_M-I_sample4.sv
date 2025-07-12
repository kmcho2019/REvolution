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

// State definitions
localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [2:0] cnt;
reg [15:0] div_reg;  // {remainder, quotient}
reg [7:0] abs_divisor;
reg result_sign;

// Absolute value computation
wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;

// Division signals
wire [8:0] sub_value = {abs_divisor, 1'b0};
wire [8:0] remainder_ext = {div_reg[15:8], 1'b0};
wire [8:0] sub_result = remainder_ext - sub_value;

always @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 1'b0;
        result <= 16'b0;
        cnt <= 3'b0;
        div_reg <= 16'b0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    // Handle sign and absolute values
                    abs_divisor <= (sign & divisor[7]) ? -divisor : divisor;
                    result_sign <= sign & (dividend[7] ^ divisor[7]);
                    
                    if (divisor == 8'b0) begin
                        // Divide by zero: remainder = dividend, quotient = max
                        result <= {dividend, 8'hFF};
                        res_valid <= 1'b1;
                        state <= DONE;
                    end else begin
                        // Initialize division registers
                        div_reg <= {8'b0, abs_dividend};
                        cnt <= 3'b0;
                        state <= CALC;
                    end
                end
            end
            
            CALC: begin
                if (cnt == 3'd7) begin
                    // Final iteration - adjust remainder if negative
                    if (div_reg[15]) begin
                        div_reg[15:8] <= div_reg[15:8] + abs_divisor;
                    end
                    
                    // Prepare final result with proper signs
                    result <= {
                        (sign & dividend[7]) ? -div_reg[15:8] : div_reg[15:8],
                        result_sign ? -div_reg[7:0] : div_reg[7:0]
                    };
                    res_valid <= 1'b1;
                    state <= DONE;
                end else begin
                    // Regular iteration step
                    if (!sub_result[8]) begin  // If subtraction result is positive
                        div_reg <= {sub_result[7:0], div_reg[7:1], 1'b1};
                    end else begin
                        div_reg <= {div_reg[15:8], div_reg[7:1], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                if (!opn_valid) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule