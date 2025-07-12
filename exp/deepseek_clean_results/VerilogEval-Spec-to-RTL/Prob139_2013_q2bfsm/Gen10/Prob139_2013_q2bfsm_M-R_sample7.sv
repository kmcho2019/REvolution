module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
localparam RESET     = 3'b000;
localparam F_PULSE   = 3'b001;
localparam MONITOR_X = 3'b010;
localparam MONITOR_Y = 3'b011;
localparam FINAL_G1  = 3'b100;
localparam FINAL_G0  = 3'b101;

reg [2:0] state;
reg [1:0] x_shift;  // Stores last 2 x values
reg [1:0] y_timer;  // Counts cycles in MONITOR_Y state

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
            end
            
            F_PULSE: begin
                f <= 0;
                state <= MONITOR_X;
            end
            
            MONITOR_X: begin
                // Shift in new x value
                x_shift <= {x_shift[0], x};
                
                // Check for 1-0-1 pattern (current x=1, previous=0, before=1)
                if (x && !x_shift[0] && x_shift[1]) begin
                    g <= 1;
                    state <= MONITOR_Y;
                    y_timer <= 0;
                end
            end
            
            MONITOR_Y: begin
                if (y) begin
                    state <= FINAL_G1;
                end
                else if (y_timer == 1) begin  // After 2 cycles (0 and 1)
                    g <= 0;
                    state <= FINAL_G0;
                end
                else begin
                    y_timer <= y_timer + 1;
                end
            end
            
            FINAL_G1: begin
                g <= 1;  // Maintain permanently
            end
            
            FINAL_G0: begin
                g <= 0;  // Maintain permanently
            end
        endcase
    end
end

endmodule