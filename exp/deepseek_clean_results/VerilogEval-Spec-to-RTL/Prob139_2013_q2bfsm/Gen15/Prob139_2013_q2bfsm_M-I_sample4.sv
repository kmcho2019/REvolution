module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
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
wire pattern_detected = (x_shift == 3'b101);

// Timeout counter for y monitoring
reg y_timeout;

// State transitions
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= IDLE;
        x_shift <= 3'b0;
        y_timeout <= 1'b0;
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        current_state <= next_state;
        x_shift <= {x_shift[1:0], x};
        
        // f output (exactly one cycle)
        f <= (current_state == IDLE && next_state == F_PULSE);
        
        // Timeout counter (counts to 1 for 2 cycles)
        if (current_state == MONITOR_Y) begin
            if (y_timeout) begin
                y_timeout <= 1'b0;
            end else if (!y) begin
                y_timeout <= 1'b1;
            end
        end else begin
            y_timeout <= 1'b0;
        end
        
        // g output
        case (next_state)
            MONITOR_Y, FINAL_SUCCESS: g <= 1'b1;
            FINAL_FAIL: g <= 1'b0;
            default: g <= 1'b0;
        endcase
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: 
            next_state = resetn ? F_PULSE : IDLE;
            
        F_PULSE: 
            next_state = MONITOR_X;
            
        MONITOR_X: 
            next_state = pattern_detected ? MONITOR_Y : MONITOR_X;
            
        MONITOR_Y: 
            if (y) 
                next_state = FINAL_SUCCESS;
            else if (y_timeout)
                next_state = FINAL_FAIL;
            else
                next_state = MONITOR_Y;
            
        FINAL_SUCCESS, FINAL_FAIL: 
            next_state = current_state;
            
        default: 
            next_state = IDLE;
    endcase
end

endmodule