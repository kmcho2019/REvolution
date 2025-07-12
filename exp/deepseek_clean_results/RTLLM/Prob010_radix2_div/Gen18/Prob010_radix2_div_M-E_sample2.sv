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

// State machine definitions
typedef enum logic [1:0] {
    IDLE,
    PREPARE,
    DIVIDE,
    FINISH
} state_t;

// Internal registers
reg [1:0] state;
reg [2:0] cnt;
reg [15:0] div_reg;
reg [7:0] abs_divisor;
reg [7:0] abs_dividend;
reg result_sign;
reg divide_by_zero;
reg divide_by_one;

// Internal signals
wire [8:0] sub_result;
wire [7:0] next_rem;
wire [7:0] next_quot;

// Non-restoring division logic
assign next_rem = div_reg[15:8];
assign sub_result = {next_rem, div_reg[7]} + {abs_divisor, 1'b0};
assign next_quot = div_reg[6:0];

always @(posedge clk or posedge rst) begin
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
                    // Check for special cases
                    divide_by_zero <= (divisor == 8'b0);
                    divide_by_one <= (divisor == 8'b1);
                    
                    // Calculate absolute values
                    abs_dividend <= sign & dividend[7] ? -dividend : dividend;
                    abs_divisor <= sign & divisor[7] ? -divisor : divisor;
                    
                    // Calculate result sign
                    result_sign <= sign & (dividend[7] ^ divisor[7]);
                    
                    state <= PREPARE;
                end
            end
            
            PREPARE: begin
                if (divide_by_zero) begin
                    // Handle divide by zero
                    result <= {dividend, 8'hFF};
                    res_valid <= 1'b1;
                    state <= IDLE;
                end else if (divide_by_one) begin
                    // Handle divide by one
                    result <= {8'b0, sign ? (result_sign ? -dividend : dividend) : dividend};
                    res_valid <= 1'b1;
                    state <= IDLE;
                end else begin
                    // Initialize division registers
                    div_reg <= {8'b0, abs_dividend};
                    cnt <= 3'b0;
                    state <= DIVIDE;
                end
            end
            
            DIVIDE: begin
                if (cnt == 3'd7) begin
                    // Final iteration
                    if (div_reg[15]) begin
                        // Restore if negative
                        div_reg[15:8] <= div_reg[15:8] + abs_divisor;
                    end
                    state <= FINISH;
                end else begin
                    // Non-restoring division step
                    if (div_reg[15]) begin
                        div_reg <= {sub_result[7:0], next_quot, 1'b1};
                    end else begin
                        div_reg <= {sub_result[7:0], next_quot, 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end
            
            FINISH: begin
                // Apply final sign if needed
                result <= {
                    sign ? (dividend[7] ? -div_reg[15:8] : div_reg[15:8]) : div_reg[15:8],
                    sign ? (result_sign ? -div_reg[7:0] : div_reg[7:0]) : div_reg[7:0]
                };
                res_valid <= 1'b1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule