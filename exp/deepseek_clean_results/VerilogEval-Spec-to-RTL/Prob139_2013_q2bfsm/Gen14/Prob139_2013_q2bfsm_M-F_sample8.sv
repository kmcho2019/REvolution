module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
localparam RESET      = 3'b000;
localparam F_PULSE    = 3'b001;
localparam DETECT     = 3'b010;
localparam MONITOR_Y  = 3'b011;
localparam G_HIGH     = 3'b100;  // Terminal state (g=1)
localparam G_LOW      = 3'b101;  // Terminal state (g=0)

reg [2:0] state;
reg [2:0] x_shift;       // Shift register for x pattern
reg [1:0] y_timer;       // Timer for y monitoring

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_shift <= 0;
        y_timer <= 0;
    end
    else begin
        case (state)
            RESET: begin
                state <= F_PULSE;
                f <= 1;
                g <= 0;
                x_shift <= 0;
                y_timer <= 0;
            end
            
            F_PULSE: begin
                f <= 0;
                state <= DETECT;
            end
            
            DETECT: begin
                x_shift <= {x_shift[1:0], x};  // Shift in new x value
                
                // Check for 101 pattern after collecting 3 samples
                if (x_shift == 3'b101) begin
                    g <= 1;
                    state <= MONITOR_Y;
                    y_timer <= 0;
                end
            end
            
            MONITOR_Y: begin
                if (y) begin
                    state <= G_HIGH;  // Permanent g=1
                end
                else if (y_timer == 2'b01) begin  // After 2 cycles (0 and 1)
                    g <= 0;
                    state <= G_LOW;   // Permanent g=0
                end
                else begin
                    y_timer <= y_timer + 1;  // Increment timeout counter
                end
            end
            
            // Terminal states - remain here until reset
            G_HIGH: g <= 1;
            G_LOW:  g <= 0;
            
            default: state <= RESET;
        endcase
    end
end

endmodule