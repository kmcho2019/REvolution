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
    IDLE,      // Initial state (reset)
    PULSE_F,   // Generate f pulse
    MONITOR    // Monitor x and y patterns
} state_t;

state_t state, next_state;
reg [2:0] x_history;  // Shift register for x pattern
reg [1:0] y_timer;    // 2-cycle timer for y monitoring
wire x_pattern_match;  // Combinatorial detection of 1-0-1

// Pattern detection
assign x_pattern_match = (x_history == 3'b101);

// State transitions
always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_history <= 3'b0;
        y_timer <= 2'b0;
    end else begin
        state <= next_state;
        x_history <= {x_history[1:0], x};
        
        // Timer logic
        if (state == MONITOR && g && !(g && y)) begin
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
        IDLE:    next_state = resetn ? PULSE_F : IDLE;
        PULSE_F: next_state = MONITOR;
        MONITOR: next_state = MONITOR; // Stay until reset
    endcase
end

// Output logic
always @(posedge clk) begin
    if (!resetn) begin
        f <= 0;
        g <= 0;
    end else begin
        // f output (one cycle pulse)
        f <= (state == IDLE && resetn);
        
        // g output logic
        if (state == MONITOR) begin
            if (x_pattern_match) begin
                g <= 1;
            end else if (g) begin
                if (y) begin
                    // Keep g=1 permanently
                end else if (y_timer == 2'b01) begin // After 2 cycles (0 and 1)
                    g <= 0;
                end
            end
        end else begin
            g <= 0;
        end
    end
end

endmodule