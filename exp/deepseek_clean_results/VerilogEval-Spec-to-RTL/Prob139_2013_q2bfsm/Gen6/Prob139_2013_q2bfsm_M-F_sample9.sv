module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam IDLE      = 3'b000;
localparam PULSE_F   = 3'b001;
localparam WAIT      = 3'b010;
localparam MONITOR_X = 3'b011;
localparam MONITOR_Y = 3'b100;
localparam G_HIGH    = 3'b101;
localparam G_LOW     = 3'b110;

reg [2:0] state, next_state;
reg [2:0] x_shift;       // Shift register for x sequence
reg y_timer;             // Timer for y monitoring (1 bit for 2 cycles)
reg g_permanent;         // Permanent g status

// Sequence detection wire
wire sequence_detected = (x_shift == 3'b101);

always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        f <= 0;
        g <= 0;
        x_shift <= 0;
        y_timer <= 0;
        g_permanent <= 0;
    end
    else begin
        state <= next_state;
        
        // Shift register for x sequence
        x_shift <= {x_shift[1:0], x};
        
        // Update outputs
        case (state)
            PULSE_F: f <= 1;
            WAIT:    f <= 0;
            MONITOR_Y: begin
                if (!g_permanent) begin
                    y_timer <= y_timer + 1;
                    if (y) begin
                        g_permanent <= 1;
                        g <= 1;
                    end
                    else if (y_timer) begin  // After 2 cycles (0→1)
                        g_permanent <= 1;
                        g <= 0;
                    end
                end
            end
            G_HIGH: g <= 1;
            G_LOW:  g <= 0;
        endcase
    end
end

always @(*) begin
    // Default next state
    next_state = state;
    
    case (state)
        IDLE: begin
            if (resetn) next_state = PULSE_F;
        end
        
        PULSE_F: next_state = WAIT;
        
        WAIT: next_state = MONITOR_X;
        
        MONITOR_X: begin
            if (sequence_detected)
                next_state = MONITOR_Y;
        end
        
        MONITOR_Y: begin
            if (g_permanent) begin
                if (g) next_state = G_HIGH;
                else   next_state = G_LOW;
            end
        end
        
        G_HIGH, G_LOW: ; // Stay in permanent state until reset
    endcase
end

endmodule