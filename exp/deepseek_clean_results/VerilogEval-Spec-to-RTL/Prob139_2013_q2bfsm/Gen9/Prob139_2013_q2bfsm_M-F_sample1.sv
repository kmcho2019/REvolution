module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State definitions
localparam RESET     = 3'b000;
localparam PULSE_F   = 3'b001;
localparam MONITOR_X = 3'b010;
localparam CHECK_Y   = 3'b011;
localparam FINAL     = 3'b100;

reg [2:0] state;
reg [2:0] x_history;  // Stores last 3 x values
reg [1:0] y_timeout;  // Counts cycles waiting for y

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_history <= 0;
        y_timeout <= 0;
    end
    else begin
        // Shift in new x value
        x_history <= {x_history[1:0], x};
        
        // Default outputs
        f <= 0;
        
        case (state)
            RESET: begin
                state <= PULSE_F;
                f <= 0;
                g <= 0;
                x_history <= 0;
                y_timeout <= 0;
            end
            
            PULSE_F: begin
                f <= 1;
                state <= MONITOR_X;
            end
            
            MONITOR_X: begin
                // Check for 1-0-1 sequence
                if (x_history == 3'b101) begin
                    g <= 1;
                    y_timeout <= 0;
                    state <= CHECK_Y;
                end
            end
            
            CHECK_Y: begin
                if (y) begin
                    state <= FINAL;  // Keep g=1 permanently
                end
                else if (y_timeout == 1) begin
                    g <= 0;
                    state <= FINAL;  // Set g=0 permanently
                end
                else begin
                    y_timeout <= y_timeout + 1;
                end
            end
            
            FINAL: begin
                // Maintain outputs until reset
                // No state changes needed
            end
        endcase
    end
end

endmodule