module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
typedef enum {
    IDLE,       // Waiting for reset deassertion
    F_PULSE,    // Generate f pulse
    MONITOR_X,  // Monitoring x sequence
    MONITOR_Y,  // Monitoring y within 2 cycles
    G_HIGH,     // Permanent g=1
    G_LOW       // Permanent g=0
} state_t;

state_t current_state, next_state;
reg [1:0] x_seq;       // Last two x values for sequence detection
reg y_timer;           // 1-bit timer for 2-cycle window
reg sequence_detected;  // Flag for 1-0-1 sequence

// State transitions
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= IDLE;
        x_seq <= 2'b00;
        y_timer <= 1'b0;
        sequence_detected <= 1'b0;
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Update x sequence history
        x_seq <= {x_seq[0], x};
        
        // Detect 1-0-1 sequence
        sequence_detected <= (x_seq == 2'b01) && (x == 1'b1);
        
        // Update y timer
        if (current_state == MONITOR_Y && !y_timer) begin
            y_timer <= 1'b1;
        end
        
        // Output generation
        case (current_state)
            F_PULSE: begin
                f <= 1'b1;
                g <= 1'b0;
            end
            MONITOR_X: begin
                f <= 1'b0;
                g <= 1'b0;
            end
            MONITOR_Y: begin
                f <= 1'b0;
                g <= 1'b1;
                if (y) begin
                    next_state <= G_HIGH;
                end else if (y_timer) begin
                    next_state <= G_LOW;
                end
            end
            G_HIGH: begin
                g <= 1'b1;
            end
            G_LOW: begin
                g <= 1'b0;
            end
            default: begin
                f <= 1'b0;
                g <= 1'b0;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:      next_state = resetn ? F_PULSE : IDLE;
        F_PULSE:   next_state = MONITOR_X;
        MONITOR_X: next_state = sequence_detected ? MONITOR_Y : MONITOR_X;
        MONITOR_Y: next_state = current_state; // Stay until y condition met
        G_HIGH:    next_state = G_HIGH;
        G_LOW:     next_state = G_LOW;
        default:   next_state = IDLE;
    endcase
end

endmodule