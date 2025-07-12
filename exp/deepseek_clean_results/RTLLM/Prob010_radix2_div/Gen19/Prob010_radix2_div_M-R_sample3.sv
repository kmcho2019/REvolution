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

// State machine
typedef enum {IDLE, CALC, DONE} state_t;
reg [1:0] state;

// Internal signals
reg [7:0] abs_divisor;
reg [7:0] pos_dividend;
reg result_sign;
reg [3:0] cnt;  // Now 4-bit for 0-8 count
reg [15:0] div_reg;  // {remainder[15:8], quotient[7:0]}

// Combinational logic
wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] effective_divisor = (sign & divisor[7]) ? -divisor : divisor;
wire div_by_zero = (divisor == 8'b0);

// Subtraction and shift logic
wire [8:0] sub_value = {abs_divisor, 1'b0};
wire [8:0] remainder_ext = {div_reg[15:8], 1'b0};
wire [8:0] sub_result = remainder_ext - sub_value;
wire sub_positive = ~sub_result[8];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 1'b0;
        result <= 16'b0;
        cnt <= 4'b0;
        div_reg <= 16'b0;
        abs_divisor <= 8'b0;
        pos_dividend <= 8'b0;
        result_sign <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    // Handle sign and absolute values
                    abs_divisor <= effective_divisor;
                    pos_dividend <= abs_dividend;
                    result_sign <= sign & (dividend[7] ^ divisor[7]);
                    
                    if (div_by_zero) begin
                        // Immediate result for divide by zero
                        result <= {dividend, 8'hFF};
                        res_valid <= 1'b1;
                        state <= DONE;
                    end else begin
                        // Initialize division registers
                        div_reg <= {8'b0, abs_dividend};
                        cnt <= 4'd1;
                        state <= CALC;
                    end
                end
            end
            
            CALC: begin
                if (cnt == 4'd8) begin
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
                    if (sub_positive) begin
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