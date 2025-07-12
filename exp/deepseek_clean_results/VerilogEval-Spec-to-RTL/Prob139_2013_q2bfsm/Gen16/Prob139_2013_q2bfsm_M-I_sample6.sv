module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
localparam RESET      = 2'b00;
localparam F_PULSE    = 2'b01;
localparam DETECT     = 2'b10;
localparam MONITOR_Y  = 2'b11;

reg [1:0] state;
reg [1:0] x_count;      // Counts collected x samples
reg [1:0] y_timer;      // Counts y monitoring cycles
reg x_prev;             // Previous x value
reg x_prev_prev;        // Previous previous x value

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_timer <= 0;
        x_prev <= 0;
        x_prev_prev <= 0;
    end
    else begin
        case (state)
            RESET: begin
                state <= F_PULSE;
                f <= 1;
                g <= 0;
            end
            
            F_PULSE: begin
                f <= 0;
                state <= DETECT;
                x_count <= 0;
                x_prev <= 0;
                x_prev_prev <= 0;
            end
            
            DETECT: begin
                // Shift in new x value
                x_prev_prev <= x_prev;
                x_prev <= x;
                x_count <= x_count + 1;
                
                // Check for 101 pattern after 3 samples
                if (x_count == 2'b10 && {x_prev_prev, x_prev, x} == 3'b101) begin
                    g <= 1;
                    state <= MONITOR_Y;
                    y_timer <= 0;
                end
            end
            
            MONITOR_Y: begin
                if (y) begin
                    g <= 1;  // Permanent g=1
                    // Stay in this state until reset
                end
                else if (y_timer == 2'b01) begin  // After 2 cycles (0 and 1)
                    g <= 0;  // Permanent g=0
                    // Stay in this state until reset
                end
                else begin
                    y_timer <= y_timer + 1;
                end
            end
            
            default: state <= RESET;
        endcase
    end
end

endmodule