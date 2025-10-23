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

// FSM states
typedef enum logic [1:0] {
    IDLE,
    PREP,
    DIVIDE,
    FINISH
} state_t;

state_t current_state, next_state;

// Internal registers
reg [7:0] abs_dividend, abs_divisor;
reg [15:0] shift_reg;  // {remainder, quotient}
reg [3:0] counter;
reg result_sign;
reg special_case;

// Division signals
wire [8:0] sub_result = {shift_reg[15:8], 1'b0} - {1'b0, abs_divisor};
wire sub_negative = sub_result[8];
wire [15:0] next_shift = sub_negative ? 
    {shift_reg[14:0], 1'b0} : 
    {sub_result[7:0], shift_reg[7:0], 1'b1};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        current_state <= IDLE;
        res_valid <= 0;
        result <= 0;
        shift_reg <= 0;
        counter <= 0;
        abs_dividend <= 0;
        abs_divisor <= 0;
        result_sign <= 0;
        special_case <= 0;
    end else begin
        current_state <= next_state;
        
        case (current_state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    next_state <= PREP;
                end
            end
            
            PREP: begin
                // Handle sign and special cases
                abs_dividend <= (sign & dividend[7]) ? -dividend : dividend;
                abs_divisor <= (sign & divisor[7]) ? -divisor : divisor;
                result_sign <= sign & (dividend[7] ^ divisor[7]);
                
                // Detect special cases
                if (divisor == 0) begin
                    special_case <= 1;
                    result <= {dividend, 8'hFF};  // Divide by zero
                    next_state <= FINISH;
                end else if (dividend == 0) begin
                    special_case <= 1;
                    result <= 0;  // Zero dividend
                    next_state <= FINISH;
                end else begin
                    special_case <= 0;
                    shift_reg <= {8'b0, abs_dividend};
                    counter <= 0;
                    next_state <= DIVIDE;
                end
            end
            
            DIVIDE: begin
                if (counter == 8) begin
                    next_state <= FINISH;
                end else begin
                    shift_reg <= next_shift;
                    counter <= counter + 1;
                end
            end
            
            FINISH: begin
                if (!special_case) begin
                    // Final remainder adjustment
                    if (shift_reg[15]) begin
                        shift_reg[15:8] <= shift_reg[15:8] + abs_divisor;
                    end
                    
                    // Apply sign correction
                    result <= {
                        (sign & dividend[7]) ? -shift_reg[15:8] : shift_reg[15:8],
                        result_sign ? -shift_reg[7:0] : shift_reg[7:0]
                    };
                end
                
                res_valid <= 1;
                next_state <= IDLE;
            end
        endcase
    end
end

// Next state logic
always_comb begin
    case (current_state)
        IDLE: next_state = opn_valid ? PREP : IDLE;
        PREP: next_state = special_case ? FINISH : DIVIDE;
        DIVIDE: next_state = (counter == 8) ? FINISH : DIVIDE;
        FINISH: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

endmodule