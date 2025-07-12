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
    IDLE,
    ACTIVE,
    FINAL
} state_t;

state_t current_state, next_state;

// Shift register for x sequence detection
reg [2:0] x_shift;

// Timer for y monitoring
reg [1:0] y_timer;
wire y_timeout = (y_timer == 2'b0);

// Sequence detected flag
wire sequence_detected = (x_shift == 3'b101);

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= IDLE;
        x_shift <= 3'b0;
        y_timer <= 2'b11; // Initialize to max value
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Update shift register
        x_shift <= {x_shift[1:0], x};
        
        // Timer logic
        if (current_state == ACTIVE && g) begin
            y_timer <= y_timer - 1;
        end
        
        // Output logic
        case (current_state)
            IDLE: begin
                f <= 1'b1; // Pulse f for one cycle
                g <= 1'b0;
            end
            ACTIVE: begin
                f <= 1'b0;
                if (sequence_detected && !g) begin
                    g <= 1'b1;
                    y_timer <= 2'b10; // Start 2-cycle timer
                end
            end
            FINAL: begin
                // g maintains its value permanently
                f <= 1'b0;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: next_state = ACTIVE;
        ACTIVE: begin
            if (g && (y || y_timeout))
                next_state = FINAL;
            else
                next_state = ACTIVE;
        end
        FINAL: next_state = FINAL;
        default: next_state = IDLE;
    endcase
end

endmodule