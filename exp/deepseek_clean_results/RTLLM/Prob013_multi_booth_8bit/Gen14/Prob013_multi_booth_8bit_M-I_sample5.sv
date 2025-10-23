module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State encoding (Gray code for power efficiency)
    typedef enum {IDLE, CALC1, CALC2, DONE} state_t;
    reg [1:0] state, next_state;
    
    // Data registers with clock gating
    reg [15:0] multiplicand, next_multiplicand;
    reg [7:0] multiplier, next_multiplier;
    reg prev_lsb, next_prev_lsb;
    reg [1:0] counter, next_counter;
    reg [15:0] next_p;
    reg [15:0] partial_sum, next_partial_sum;
    reg [15:0] partial_carry, next_partial_carry;
    
    // Clock gating signals
    wire calc_active = (state == CALC1 || state == CALC2);
    wire clk_gated = clk & (~reset & calc_active);
    
    // Booth encoding stage 1 (combinational)
    wire [1:0] booth_sel;
    wire [15:0] booth_operand;
    
    assign booth_sel = {multiplier[1:0], prev_lsb};
    assign booth_operand = 
        (booth_sel == 3'b001 || booth_sel == 3'b010) ? multiplicand :
        (booth_sel == 3'b011) ? (multiplicand << 1) :
        (booth_sel == 3'b100) ? (multiplicand << 1) :
        (booth_sel == 3'b101 || booth_sel == 3'b110) ? multiplicand :
        16'b0;
    
    wire booth_add = (booth_sel == 3'b001 || booth_sel == 3'b010 || booth_sel == 3'b011);
    wire booth_sub = (booth_sel == 3'b100 || booth_sel == 3'b101 || booth_sel == 3'b110);
    
    // Carry-save adder for partial products
    wire [15:0] sum_out, carry_out;
    assign sum_out = partial_sum ^ partial_carry ^ (booth_add ? booth_operand : (booth_sub ? ~booth_operand : 16'b0));
    assign carry_out = (partial_sum & partial_carry) | 
                      (partial_sum & (booth_add ? booth_operand : (booth_sub ? ~booth_operand : 16'b0))) | 
                      (partial_carry & (booth_add ? booth_operand : (booth_sub ? ~booth_operand : 16'b0))) << 1;
    
    // Next state and output combinational logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_p = p;
        next_multiplicand = multiplicand;
        next_multiplier = multiplier;
        next_prev_lsb = prev_lsb;
        next_counter = counter;
        next_partial_sum = partial_sum;
        next_partial_carry = partial_carry;
        rdy = 1'b0;
        
        case (state)
            IDLE: begin
                if (!reset) begin
                    next_state = CALC1;
                    next_multiplicand = {{8{a[7]}}, a};
                    next_multiplier = b;
                    next_prev_lsb = 1'b0;
                    next_p = 16'b0;
                    next_partial_sum = 16'b0;
                    next_partial_carry = 16'b0;
                    next_counter = 2'b0;
                end
            end
            
            CALC1: begin
                next_partial_sum = sum_out;
                next_partial_carry = carry_out;
                next_state = CALC2;
            end
            
            CALC2: begin
                next_multiplicand = multiplicand << 2;
                next_prev_lsb = multiplier[1];
                next_multiplier = multiplier >> 2;
                next_counter = counter + 1;
                
                if (counter == 2'b11) begin
                    next_state = DONE;
                    next_p = sum_out + (carry_out << 1);
                end else begin
                    next_state = CALC1;
                end
            end
            
            DONE: begin
                rdy = 1'b1;
                if (reset)
                    next_state = IDLE;
            end
        endcase
    end
    
    // Sequential logic with clock gating
    always @(posedge clk_gated or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            p <= 16'b0;
            multiplicand <= 16'b0;
            multiplier <= 8'b0;
            prev_lsb <= 1'b0;
            counter <= 2'b0;
            partial_sum <= 16'b0;
            partial_carry <= 16'b0;
        end else begin
            state <= next_state;
            p <= next_p;
            multiplicand <= next_multiplicand;
            multiplier <= next_multiplier;
            prev_lsb <= next_prev_lsb;
            counter <= next_counter;
            partial_sum <= next_partial_sum;
            partial_carry <= next_partial_carry;
        end
    end

endmodule