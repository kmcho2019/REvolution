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
    reg [1:0] state;
    
    // Data registers
    reg [15:0] multiplicand;
    reg [2:0] multiplier; // Only need 3 bits (2 current + prev_lsb)
    reg [1:0] counter;
    
    // Pre-computed values
    wire [15:0] multiplicand_x1 = multiplicand;
    wire [15:0] multiplicand_x2 = multiplicand << 1;
    
    // Next state and data values
    reg [1:0] next_state;
    reg [15:0] next_multiplicand;
    reg [2:0] next_multiplier;
    reg [1:0] next_counter;
    reg [15:0] next_p;
    reg next_rdy;
    
    // Booth encoding combinational logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_p = p;
        next_multiplicand = multiplicand;
        next_multiplier = multiplier;
        next_counter = counter;
        next_rdy = 1'b0;
        
        case (state)
            IDLE: begin
                if (!reset) begin
                    next_state = CALC;
                    next_multiplicand = {{8{a[7]}}, a};
                    next_multiplier = {b[1:0], 1'b0}; // Initialize with b[1:0] and prev_lsb=0
                    next_p = 16'b0;
                    next_counter = 2'b0;
                end
            end
            
            CALC: begin
                // Booth encoding and accumulation
                case (multiplier)
                    3'b000, 3'b111: next_p = p;
                    3'b001, 3'b010: next_p = p + multiplicand_x1;
                    3'b011:         next_p = p + multiplicand_x2;
                    3'b100:         next_p = p - multiplicand_x2;
                    3'b101, 3'b110: next_p = p - multiplicand_x1;
                endcase
                
                // Update for next iteration
                next_multiplicand = multiplicand << 2;
                next_multiplier = {b[counter*2+3:counter*2+2], multiplier[1]}; // Get next 2 bits
                next_counter = counter + 1;
                
                if (counter == 2'b11)
                    next_state = DONE;
            end
            
            DONE: begin
                next_rdy = 1'b1;
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
            multiplier <= 3'b0;
            counter <= 2'b0;
            rdy <= 1'b0;
        end else begin
            state <= next_state;
            p <= next_p;
            multiplicand <= next_multiplicand;
            multiplier <= next_multiplier;
            counter <= next_counter;
            rdy <= next_rdy;
        end
    end

endmodule