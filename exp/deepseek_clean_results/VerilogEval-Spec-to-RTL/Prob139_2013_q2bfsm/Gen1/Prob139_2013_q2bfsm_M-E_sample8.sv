module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
typedef enum {
    IDLE,
    SEQUENCE_DETECT,
    FINAL
} state_t;

reg [1:0] state, next_state;

// Shift register for x sequence detection
reg [2:0] x_shift;
always @(posedge clk) begin
    if (!resetn) begin
        x_shift <= 3'b0;
    end else begin
        x_shift <= {x_shift[1:0], x};
    end
end

// Timer for y monitoring (0-2 cycles)
reg [1:0] y_timer;
wire sequence_detected = (x_shift == 3'b101);

// State transitions
always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        f <= 0;
        g <= 0;
        y_timer <= 0;
    end else begin
        state <= next_state;
        
        case (state)
            IDLE: begin
                f <= 1;  // Pulse f for one cycle after reset
                y_timer <= 0;
            end
            
            SEQUENCE_DETECT: begin
                f <= 0;
                if (sequence_detected) begin
                    g <= 1;
                    y_timer <= 0;  // Start monitoring y
                end
            end
            
            FINAL: begin
                // Maintain g value permanently
                // No state changes until reset
            end
        endcase
        
        // Timer increment when in SEQUENCE_DETECT with g=1
        if (state == SEQUENCE_DETECT && g) begin
            y_timer <= y_timer + 1;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: next_state = SEQUENCE_DETECT;
        
        SEQUENCE_DETECT: begin
            if (g) begin
                if (y || y_timer == 2) begin
                    next_state = FINAL;
                end else begin
                    next_state = SEQUENCE_DETECT;
                end
            end else begin
                next_state = SEQUENCE_DETECT;
            end
        end
        
        FINAL: next_state = FINAL;
        
        default: next_state = IDLE;
    endcase
end

// Final g value handling
always @(posedge clk) begin
    if (!resetn) begin
        g <= 0;
    end else if (state == SEQUENCE_DETECT && g && y_timer == 2 && !y) begin
        g <= 0;  // Timeout without y=1
    end
end

endmodule