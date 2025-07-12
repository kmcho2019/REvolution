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
    reg [8:0] multiplier;  // 8-bit + previous LSB
    reg [2:0] counter, next_counter;
    
    // Pre-computed values
    wire [15:0] multiplicand_x1 = multiplicand;
    wire [15:0] multiplicand_x2 = multiplicand << 1;
    
    // Booth operation result
    wire [15:0] booth_result;
    
    // Booth encoding combinational logic
    assign booth_result = 
        (multiplier[2:0] == 3'b001 || multiplier[2:0] == 3'b010) ? p + multiplicand_x1 :
        (multiplier[2:0] == 3'b011) ? p + multiplicand_x2 :
        (multiplier[2:0] == 3'b100) ? p - multiplicand_x2 :
        (multiplier[2:0] == 3'b101 || multiplier[2:0] == 3'b110) ? p - multiplicand_x1 :
        p; // Default case (000,111)
    
    // Next state and output combinational logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_multiplicand = multiplicand;
        next_counter = counter;
        rdy = 1'b0;
        
        case (state)
            IDLE: begin
                if (!reset) begin
                    next_state = CALC;
                    next_multiplicand = {{8{a[7]}}, a};
                    next_counter = 3'b0;
                end
            end
            
            CALC: begin
                next_multiplicand = multiplicand << 2;
                next_counter = counter + 1;
                
                if (counter == 3'b100)  // After 4 iterations
                    next_state = DONE;
            end
            
            DONE: begin
                rdy = 1'b1;
                if (reset)
                    next_state = IDLE;
            end
        endcase
    end
    
    // Sequential logic with clock gating
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            p <= 16'b0;
            multiplicand <= 16'b0;
            multiplier <= {b, 1'b0};
            counter <= 3'b0;
        end else begin
            state <= next_state;
            counter <= next_counter;
            multiplicand <= next_multiplicand;
            
            if (state == CALC) begin
                p <= booth_result;
                multiplier <= multiplier >> 2;
            end
            
            if (state == IDLE && !reset) begin
                p <= 16'b0;
                multiplier <= {b, 1'b0};
            end
        end
    end

endmodule