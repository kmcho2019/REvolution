module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam IDLE        = 2'b00;
localparam PULSE_F     = 2'b01;
localparam WAIT_PATTERN = 2'b10;
localparam CHECK_Y     = 2'b11;

reg [1:0] state, next_state;
reg [2:0] x_shift;       // Shift register for x pattern
reg [1:0] y_timer;       // Timer for y monitoring
reg y_reg;               // Registered version of y
reg g_high_permanent;    // Flag for permanent g=1
reg g_low_permanent;     // Flag for permanent g=0

// Register y input for clean edge detection
always @(posedge clk) begin
    y_reg <= y;
end

// Main state machine
always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        f <= 0;
        g <= 0;
        x_shift <= 0;
        y_timer <= 0;
        g_high_permanent <= 0;
        g_low_permanent <= 0;
    end else begin
        state <= next_state;
        
        // Shift register for x pattern detection
        x_shift <= {x_shift[1:0], x};
        
        // Handle terminal states
        if (g_high_permanent) begin
            g <= 1;
        end else if (g_low_permanent) begin
            g <= 0;
        end
        
        // State-specific logic
        case (state)
            PULSE_F: begin
                f <= 1;
                g <= 0;
            end
            WAIT_PATTERN: begin
                f <= 0;
                if (x_shift == 3'b101) begin
                    g <= 1;
                end
            end
            CHECK_Y: begin
                f <= 0;
                if (y_reg) begin
                    g_high_permanent <= 1;
                end else if (y_timer == 2'b01) begin  // After 2 cycles
                    g_low_permanent <= 1;
                end
                y_timer <= y_timer + 1;
            end
            default: begin
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: next_state = PULSE_F;
        PULSE_F: next_state = WAIT_PATTERN;
        WAIT_PATTERN: 
            next_state = (x_shift == 3'b101) ? CHECK_Y : WAIT_PATTERN;
        CHECK_Y:
            if (g_high_permanent || g_low_permanent)
                next_state = CHECK_Y;  // Stay until reset
            else
                next_state = CHECK_Y;
        default: next_state = IDLE;
    endcase
end

endmodule