module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// States
typedef enum logic [2:0] {
    RESET,
    MONITOR_X,
    MONITOR_Y,
    DONE
} state_t;

state_t current_state, next_state;

// Shift register for x sequence detection
reg [2:0] x_shift;

// Timeout counter for y monitoring
reg timeout_expired;

// Output assignments
assign f = (current_state == RESET);
assign g = (current_state == DONE) ? !timeout_expired : 
           (current_state == MONITOR_Y);

always @(posedge clk) begin
    if (!resetn) begin
        current_state <= RESET;
        x_shift <= 3'b000;
        timeout_expired <= 1'b0;
    end else begin
        current_state <= next_state;
        x_shift <= {x_shift[1:0], x};
        
        case (current_state)
            RESET: begin
                next_state <= MONITOR_X;
            end
            
            MONITOR_X: begin
                if (x_shift == 3'b101) begin
                    timeout_expired <= 1'b0;
                    next_state <= MONITOR_Y;
                end else begin
                    next_state <= MONITOR_X;
                end
            end
            
            MONITOR_Y: begin
                if (y) begin
                    next_state <= DONE;
                end else if (timeout_expired) begin
                    next_state <= DONE;
                end else begin
                    timeout_expired <= 1'b1;
                    next_state <= MONITOR_Y;
                end
            end
            
            DONE: begin
                next_state <= DONE;  // Stay here until reset
            end
            
            default: next_state <= RESET;
        endcase
    end
end

endmodule