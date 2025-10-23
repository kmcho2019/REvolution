module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
localparam RESET       = 2'b00;
localparam F_PULSE     = 2'b01;
localparam WAIT_PATTERN = 2'b10;
localparam MONITOR_Y   = 2'b11;

reg [1:0] state;
reg [1:0] x_history;
reg [1:0] y_counter;

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_history <= 0;
        y_counter <= 0;
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
                state <= WAIT_PATTERN;
                x_history <= {x_history[0], x};
            end
            
            WAIT_PATTERN: begin
                x_history <= {x_history[0], x};
                
                // Check for 1-0-1 pattern in last 3 cycles
                if ({x_history, x} == 3'b101) begin
                    g <= 1;
                    state <= MONITOR_Y;
                    y_counter <= 0;
                end
            end
            
            MONITOR_Y: begin
                if (y) begin
                    // Keep g=1 permanently
                    state <= MONITOR_Y;
                end
                else if (y_counter < 2) begin
                    y_counter <= y_counter + 1;
                end
                else begin
                    g <= 0;
                    // Stay in this state with g=0 until reset
                end
            end
        endcase
    end
end

endmodule