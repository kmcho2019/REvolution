module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output reg g
);

// State encoding
typedef enum logic [2:0] {
    IDLE,
    F_PULSE,
    MONITOR_X,
    MONITOR_Y,
    FINAL_SUCCESS,
    FINAL_FAIL
} state_t;

state_t current_state, next_state;

// Sequence detection
reg [2:0] x_shift;
reg pattern_detected;

// Timeout counter for y monitoring
reg [1:0] y_timeout;

// State transitions
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= IDLE;
        x_shift <= 3'b0;
        pattern_detected <= 1'b0;
        y_timeout <= 2'b0;
    end else begin
        current_state <= next_state;
        x_shift <= {x_shift[1:0], x};
        
        // Pattern detection (edge sensitive)
        pattern_detected <= (x_shift == 3'b101);
        
        // Timeout counter
        if (current_state == MONITOR_Y && !y)
            y_timeout <= y_timeout + 1;
        else
            y_timeout <= 2'b0;
    end
end

// Next state logic
always @(*) begin
    next_state = current_state;
    
    case (current_state)
        IDLE: 
            if (resetn) 
                next_state = F_PULSE;
                
        F_PULSE: 
            next_state = MONITOR_X;
            
        MONITOR_X: 
            if (pattern_detected)
                next_state = MONITOR_Y;
                
        MONITOR_Y: 
            if (y)
                next_state = FINAL_SUCCESS;
            else if (y_timeout == 2'b01) // Decision at 2 cycles
                next_state = FINAL_FAIL;
                
        FINAL_SUCCESS, FINAL_FAIL: 
            next_state = current_state;
            
        default: 
            next_state = IDLE;
    endcase
end

// f output (combinatorial for precise timing)
assign f = (current_state == F_PULSE);

// g output (registered)
always @(posedge clk) begin
    if (!resetn) begin
        g <= 1'b0;
    end else begin
        case (current_state)
            MONITOR_Y:    g <= 1'b1;
            FINAL_SUCCESS: g <= 1'b1;
            FINAL_FAIL:    g <= 1'b0;
            default:       g <= 1'b0;
        endcase
    end
end

endmodule