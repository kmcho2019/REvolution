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

reg [1:0] state;
reg [2:0] x_shift;       // Shift register for x sequence
reg [1:0] y_timer;       // Timer for y monitoring
reg g_permanent;          // Permanent g status
reg g_status;            // 1 = keep g on, 0 = keep g off

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
        g_status <= 0;
    end
    else begin
        // Shift register for x sequence
        x_shift <= {x_shift[1:0], x};
        
        case (state)
            IDLE: begin
                f <= 0;
                g <= 0;
                state <= PULSE_F;
            end
            
            PULSE_F: begin
                f <= 1;
                g <= 0;
                state <= MONITOR_X;
            end
            
            MONITOR_X: begin
                f <= 0;
                if (sequence_detected) begin
                    g <= 1;
                    state <= MONITOR_Y;
                    y_timer <= 2'b00;
                end
            end
            
            MONITOR_Y: begin
                if (y) begin
                    g_status <= 1;
                    g_permanent <= 1;
                end
                else if (y_timer == 2'b10) begin
                    g_status <= 0;
                    g_permanent <= 1;
                end
                
                if (!g_permanent) begin
                    y_timer <= y_timer + 1;
                end
                else begin
                    g <= g_status;
                end
            end
        endcase
    end
end

endmodule