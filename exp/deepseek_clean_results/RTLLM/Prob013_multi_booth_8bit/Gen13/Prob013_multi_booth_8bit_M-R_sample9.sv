module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State encoding
    typedef enum {IDLE, CALC, DONE} state_t;
    reg [1:0] state, next_state;
    
    // Data registers
    reg [15:0] multiplicand, next_multiplicand;
    reg [7:0] multiplier, next_multiplier;
    reg prev_lsb, next_prev_lsb;
    reg [1:0] counter, next_counter;
    reg [15:0] next_p;
    
    // Pre-computed values
    wire [15:0] multiplicand_x1 = multiplicand;
    wire [15:0] multiplicand_x2 = multiplicand << 1;
    
    // Booth encoding result
    wire [15:0] booth_result;
    
    // Booth encoding combinational logic
    assign booth_result = 
        ({multiplier[1:0], prev_lsb} == 3'b001 || {multiplier[1:0], prev_lsb} == 3'b010) ? p + multiplicand_x1 :
        ({multiplier[1:0], prev_lsb} == 3'b011) ? p + multiplicand_x2 :
        ({multiplier[1:0], prev_lsb} == 3'b100) ? p - multiplicand_x2 :
        ({multiplier[1:0], prev_lsb} == 3'b101 || {multiplier[1:0], prev_lsb} == 3'b110) ? p - multiplicand_x1 :
        p; // Default case (000,111)
    
    // Next state and output combinational logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_p = p;
        next_multiplicand = multiplicand;
        next_multiplier = multiplier;
        next_prev_lsb = prev_lsb;
        next_counter = counter;
        rdy = 1'b0;
        
        case (state)
            IDLE: begin
                if (!reset) begin
                    next_state = CALC;
                    next_multiplicand = {{8{a[7]}}, a};
                    next_multiplier = b;
                    next_prev_lsb = 1'b0;
                    next_p = 16'b0;
                    next_counter = 2'b0;
                end
            end
            
            CALC: begin
                next_p = booth_result;
                next_multiplicand = multiplicand << 2;
                next_prev_lsb = multiplier[1];
                next_multiplier = multiplier >> 2;
                next_counter = counter + 1;
                
                if (counter == 2'b11)
                    next_state = DONE;
            end
            
            DONE: begin
                rdy = 1'b1;
                if (reset)
                    next_state = IDLE;
            end
        endcase
    end
    
    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            p <= 16'b0;
            multiplicand <= 16'b0;
            multiplier <= 8'b0;
            prev_lsb <= 1'b0;
            counter <= 2'b0;
        end else begin
            state <= next_state;
            p <= next_p;
            multiplicand <= next_multiplicand;
            multiplier <= next_multiplier;
            prev_lsb <= next_prev_lsb;
            counter <= next_counter;
        end
    end

endmodule