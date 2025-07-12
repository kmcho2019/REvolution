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

// Control FSM states
typedef enum logic [1:0] {
    IDLE,
    PREPARE,
    DIVIDE,
    FINISH
} state_t;

state_t state;

// Datapath registers
reg [7:0] abs_divisor;
reg [7:0] abs_dividend;
reg [15:0] working_reg;  // {remainder, quotient}
reg [2:0] iteration;
reg result_sign;
reg remainder_sign;
reg div_by_zero;

// Parallel subtraction results
wire [8:0] sub_results [0:7];
wire [7:0] carry_bits;

// Generate parallel subtractors
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : sub_units
        assign sub_results[i] = {working_reg[15:8], 1'b0} + 
                              {1'b0, ~abs_divisor + 1'b1};
        assign carry_bits[i] = ~sub_results[i][8];
    end
endgenerate

// Leading-one detection for optimization
wire [2:0] leading_one_pos;
assign leading_one_pos = 
    (abs_divisor[7]) ? 3'd7 :
    (abs_divisor[6]) ? 3'd6 :
    (abs_divisor[5]) ? 3'd5 :
    (abs_divisor[4]) ? 3'd4 :
    (abs_divisor[3]) ? 3'd3 :
    (abs_divisor[2]) ? 3'd2 :
    (abs_divisor[1]) ? 3'd1 : 3'd0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        working_reg <= 0;
        iteration <= 0;
        div_by_zero <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Handle sign and absolute values
                    abs_dividend <= sign & dividend[7] ? -dividend : dividend;
                    abs_divisor <= sign & divisor[7] ? -divisor : divisor;
                    result_sign <= sign & (dividend[7] ^ divisor[7]);
                    remainder_sign <= sign & dividend[7];
                    div_by_zero <= (divisor == 0);
                    
                    working_reg <= {8'b0, abs_dividend};
                    iteration <= 7 - leading_one_pos;  // Start based on divisor magnitude
                    state <= PREPARE;
                end
            end
            
            PREPARE: begin
                if (div_by_zero) begin
                    result <= {8'hFF, 8'hFF};  // Division by zero result
                    res_valid <= 1;
                    state <= IDLE;
                end else begin
                    state <= DIVIDE;
                end
            end
            
            DIVIDE: begin
                if (iteration == 3'd7) begin
                    state <= FINISH;
                end
                
                // Select the appropriate subtraction result
                working_reg <= carry_bits[iteration] ? 
                    {sub_results[iteration][7:0], working_reg[7:0], 1'b1} :
                    {working_reg[14:0], 1'b0};
                
                iteration <= iteration + 1;
            end
            
            FINISH: begin
                // Final remainder adjustment if negative
                if (working_reg[15]) begin
                    working_reg[15:8] <= working_reg[15:8] + abs_divisor;
                end
                
                // Apply proper signs
                result <= {
                    remainder_sign ? -working_reg[15:8] : working_reg[15:8],
                    result_sign ? -working_reg[7:0] : working_reg[7:0]
                };
                
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule