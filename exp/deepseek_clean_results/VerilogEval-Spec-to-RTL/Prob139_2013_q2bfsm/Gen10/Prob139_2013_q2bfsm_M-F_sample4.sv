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

// Timer for y monitoring (0-1-2 cycles)
reg [1:0] y_timer;

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
        
        // Handle f output (one-cycle pulse after reset)
        if (state == RESET && resetn) begin
            f <= 1'b1;
        end else begin
            f <= 1'b0;
        end
        
        // Handle g output (permanent once set in MONITOR_Y)
        if (state == MONITOR_Y) begin
            if (y) begin
                g <= 1'b1;
            end else if (y_timer == 2'b10) begin // After 2 cycles
                g <= 1'b0;
            end
        end
        
        // Update y timer (only in MONITOR_Y state)
        if (state == MONITOR_Y && !g && !y) begin
            y_timer <= y_timer + 1;
        end else begin
            y_timer <= 2'b0;
        end
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    
    case (state)
        RESET: begin
            if (resetn) begin
                next_state = MONITOR_X;
            end
        end
        
        MONITOR_X: begin
            if (sequence_detected) begin
                next_state = MONITOR_Y;
            end
        end
        
        MONITOR_Y: begin
            // Stay in this state until reset
            next_state = MONITOR_Y;
        end
    endcase
end

endmodule