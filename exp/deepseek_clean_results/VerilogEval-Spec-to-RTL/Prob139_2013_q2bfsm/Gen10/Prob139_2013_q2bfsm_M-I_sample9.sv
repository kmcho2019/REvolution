module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
typedef enum logic [2:0] {
    RESET,
    PULSE_F,
    MONITOR_X,
    WAIT_Y,
    FINAL
} state_t;

state_t current_state, next_state;

// Shift register for x sequence detection
reg [2:0] x_shift;

// Timer for y monitoring
reg [1:0] y_timer;

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= RESET;
        x_shift <= 3'b0;
        y_timer <= 2'b0;
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Update shift register
        x_shift <= {x_shift[1:0], x};
        
        // Timer logic
        if (current_state == WAIT_Y) begin
            y_timer <= y_timer + 1;
        end else begin
            y_timer <= 2'b0;
        end
        
        // Output logic
        case (current_state)
            RESET: begin
                f <= 1'b0;
                g <= 1'b0;
            end
            PULSE_F: begin
                f <= 1'b1;
                g <= 1'b0;
            end
            MONITOR_X: begin
                f <= 1'b0;
                if (x_shift == 3'b101) begin
                    g <= 1'b1;
                end else begin
                    g <= 1'b0;
                end
            end
            WAIT_Y: begin
                f <= 1'b0;
                // g maintains its value
            end
            FINAL: begin
                f <= 1'b0;
                // g maintains its value permanently
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        RESET: next_state = resetn ? PULSE_F : RESET;
        PULSE_F: next_state = MONITOR_X;
        MONITOR_X: begin
            if (x_shift == 3'b101)
                next_state = WAIT_Y;
            else
                next_state = MONITOR_X;
        end
        WAIT_Y: begin
            if (y)
                next_state = FINAL;
            else if (y_timer == 2'b01) // After 2 cycles (0 and 1)
                next_state = FINAL;
            else
                next_state = WAIT_Y;
        end
        FINAL: next_state = FINAL;
        default: next_state = RESET;
    endcase
end

endmodule