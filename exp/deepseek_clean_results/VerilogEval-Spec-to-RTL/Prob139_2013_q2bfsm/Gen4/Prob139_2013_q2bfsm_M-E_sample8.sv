module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
typedef enum logic [1:0] {
    INIT,
    DETECT,
    MONITOR
} state_t;

state_t current_state, next_state;
reg [1:0] x_shift;      // Shift register for sequence detection
reg [1:0] monitor_timer; // Timer for y monitoring
reg seq_found;           // Sequence detected flag
reg y_detected;          // y=1 detected during monitoring

// State transition logic
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= INIT;
        x_shift <= 2'b00;
        monitor_timer <= 2'b00;
        seq_found <= 1'b0;
        y_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Shift register for sequence detection
        x_shift <= {x_shift[0], x};
        
        // Sequence detection logic
        if (current_state == DETECT && x_shift == 2'b10 && x == 1'b1) begin
            seq_found <= 1'b1;
        end
        
        // Monitoring timer logic
        if (current_state == MONITOR) begin
            if (y) begin
                y_detected <= 1'b1;
            end else if (monitor_timer < 2'b10) begin
                monitor_timer <= monitor_timer + 1'b1;
            end
        end
    end
end

// Next state logic
always @(*) begin
    next_state = current_state;
    
    case (current_state)
        INIT: begin
            if (resetn) begin
                next_state = DETECT;
            end
        end
        
        DETECT: begin
            if (seq_found) begin
                next_state = MONITOR;
            end
        end
        
        MONITOR: begin
            // Stay in monitor state until reset
        end
    endcase
end

// Output generation
always @(posedge clk) begin
    if (!resetn) begin
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        // f output (one cycle pulse after reset)
        if (current_state == INIT && next_state == DETECT) begin
            f <= 1'b1;
        end else begin
            f <= 1'b0;
        end
        
        // g output logic
        if (current_state == MONITOR) begin
            if (y_detected || (monitor_timer < 2'b10)) begin
                g <= 1'b1;
            end else begin
                g <= 1'b0;
            end
        end else begin
            g <= 1'b0;
        end
    end
end

endmodule