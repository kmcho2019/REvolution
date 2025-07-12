module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam IDLE     = 2'b00;
localparam PULSE_F  = 2'b01;
localparam MONITOR_X = 2'b10;
localparam MONITOR_Y = 2'b11;

reg [1:0] state, next_state;
reg [2:0] x_shift;       // Shift register for x sequence
reg [1:0] y_timer;       // Timer for y monitoring
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
        
        // y monitoring timer
        if (state == MONITOR_Y && !g_permanent)
            y_timer <= y_timer + 1;
    end
end

always @(*) begin
    // Default outputs and next state
    f = 0;
    g = 0;
    next_state = state;
    
    case (state)
        IDLE: begin
            if (resetn) next_state = PULSE_F;
        end
        
        PULSE_F: begin
            f = 1;
            next_state = MONITOR_X;
        end
        
        MONITOR_X: begin
            if (sequence_detected) begin
                g = 1;
                next_state = MONITOR_Y;
            end
        end
        
        MONITOR_Y: begin
            g = 1;
            
            if (y) begin
                g_permanent = 1;
            end
            else if (y_timer == 2'b10) begin
                g_permanent = 1;
                g = 0;
            end
        end
    endcase
    
    // Override g output if in permanent state
    if (g_permanent)
        g = (state == MONITOR_Y) && y;
end

endmodule