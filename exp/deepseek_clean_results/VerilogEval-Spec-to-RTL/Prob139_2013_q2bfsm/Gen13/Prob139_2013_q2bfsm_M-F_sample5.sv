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
reg [1:0] x_sample_cnt;  // Counter for x samples
reg y_timeout;           // Flag for y timeout

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_shift <= 0;
        x_sample_cnt <= 0;
        y_timeout <= 0;
    end
    else begin
        case (state)
            RESET: begin
                state <= F_PULSE;
                f <= 1;
                g <= 0;
                x_shift <= 0;
                x_sample_cnt <= 0;
            end
            
            F_PULSE: begin
                f <= 0;
                state <= DETECT;
            end
            
            DETECT: begin
                x_shift <= {x_shift[1:0], x};
                
                if (x_sample_cnt < 2'b10) begin  // Wait for 3 samples (0,1,2)
                    x_sample_cnt <= x_sample_cnt + 1;
                end
                else if (x_shift == 3'b101) begin  // Check pattern after 3 samples
                    g <= 1;
                    state <= MONITOR_Y;
                    y_timeout <= 0;
                end
                else begin
                    x_shift <= {x_shift[1:0], x};  // Keep shifting if no match
                    x_sample_cnt <= 2'b01;         // Overlap samples for continuous checking
                end
            end
            
            MONITOR_Y: begin
                if (y) begin
                    state <= G_HIGH;  // Permanent g=1
                end
                else if (y_timeout) begin
                    g <= 0;
                    state <= G_LOW;   // Permanent g=0
                end
                else begin
                    y_timeout <= 1;   // Mark timeout after first cycle
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