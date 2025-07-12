module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
typedef enum {
    STATE_A,  // Reset state
    STATE_B,  // Pulse f
    STATE_C,  // Detect 1-0-1 sequence
    STATE_D   // Check y within 2 cycles
} state_t;

reg [1:0] state, next_state;
reg [1:0] x_history;  // Shift register for x sequence
reg [1:0] timeout_counter;

// State transition and output logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
        x_history <= 2'b00;
        timeout_counter <= 0;
    end
    else begin
        state <= next_state;
        
        // Update x history shift register
        x_history <= {x_history[0], x};
        
        // Output and counter logic
        case (state)
            STATE_A: begin
                f <= 0;
                g <= 0;
            end
            
            STATE_B: begin
                f <= 1;  // Pulse f for one cycle
            end
            
            STATE_C: begin
                f <= 0;
                // Sequence detection happens in next_state logic
            end
            
            STATE_D: begin
                f <= 0;
                if (y) begin
                    g <= 1;  // Keep g=1 permanently
                end
                else if (timeout_counter == 2) begin
                    g <= 0;  // Timeout, set g=0 permanently
                end
                
                // Increment timeout counter
                if (!y && timeout_counter < 2) begin
                    timeout_counter <= timeout_counter + 1;
                end
            end
        endcase
        
        // Reset counter when leaving STATE_D
        if (next_state != STATE_D) begin
            timeout_counter <= 0;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        STATE_A: next_state = resetn ? STATE_B : STATE_A;
        
        STATE_B: next_state = STATE_C;
        
        STATE_C: begin
            if (x_history == 2'b01 && x == 1) begin  // Detected 1-0-1 sequence
                next_state = STATE_D;
            end
            else begin
                next_state = STATE_C;
            end
        end
        
        STATE_D: begin
            if (y || timeout_counter == 2) begin
                next_state = STATE_D;  // Stay permanently
            end
            else begin
                next_state = STATE_D;  // Continue waiting
            end
        end
        
        default: next_state = STATE_A;
    endcase
end

endmodule