module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
typedef enum logic [1:0] {
    RESET,
    MONITOR_X,
    MONITOR_Y
} state_t;

state_t state, next_state;

// Shift register for x sequence detection
reg [2:0] x_shift;
wire sequence_detected = (x_shift == 3'b101);

// Timer for y monitoring
reg [1:0] y_timer;

// Control signals
reg set_f;
reg set_g;
reg clear_g;

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        x_shift <= 3'b0;
        y_timer <= 2'b0;
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        state <= next_state;
        
        // Update x shift register
        x_shift <= {x_shift[1:0], x};
        
        // Handle f output (one-cycle pulse)
        if (set_f) f <= 1'b1;
        else f <= 1'b0;
        
        // Handle g output (permanent once set)
        if (set_g) g <= 1'b1;
        else if (clear_g) g <= 1'b0;
        
        // Update y timer (only in MONITOR_Y state)
        if (state == MONITOR_Y) begin
            if (y) begin
                y_timer <= 2'b11; // Mark as done
            end else if (y_timer < 2'b10) begin
                y_timer <= y_timer + 1;
            end
        end else begin
            y_timer <= 2'b0;
        end
    end
end

// Next state logic
always @(*) begin
    set_f = 1'b0;
    set_g = 1'b0;
    clear_g = 1'b0;
    next_state = state;
    
    case (state)
        RESET: begin
            if (resetn) begin
                set_f = 1'b1;
                next_state = MONITOR_X;
            end
        end
        
        MONITOR_X: begin
            if (sequence_detected) begin
                next_state = MONITOR_Y;
            end
        end
        
        MONITOR_Y: begin
            if (y) begin
                set_g = 1'b1;
            end else if (y_timer == 2'b01) begin // After 2 cycles
                clear_g = 1'b1;
            end
            
            // Stay in this state until reset
            if (set_g || clear_g) begin
                next_state = MONITOR_Y;
            end
        end
    endcase
end

endmodule