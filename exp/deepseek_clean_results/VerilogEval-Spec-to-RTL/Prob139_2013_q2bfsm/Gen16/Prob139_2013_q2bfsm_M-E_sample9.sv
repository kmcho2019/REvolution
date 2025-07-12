module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg state;
reg [2:0] x_pattern;
reg [1:0] y_timer;
reg pattern_matched;

localparam IDLE = 1'b0;
localparam ACTIVE = 1'b1;

always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        f <= 0;
        g <= 0;
        x_pattern <= 0;
        y_timer <= 0;
        pattern_matched <= 0;
    end else begin
        // Shift register for x pattern detection
        x_pattern <= {x_pattern[1:0], x};
        
        case (state)
            IDLE: begin
                // Generate f pulse for one cycle
                f <= 1;
                state <= ACTIVE;
            end
            
            ACTIVE: begin
                f <= 0;  // f is only high for one cycle
                
                // Detect 1-0-1 pattern on x
                if (x_pattern == 3'b101 && !pattern_matched) begin
                    g <= 1;
                    pattern_matched <= 1;
                    y_timer <= 0;
                end
                
                // Handle y monitoring when g is set
                if (g) begin
                    if (y) begin
                        // Keep g permanently high
                        y_timer <= 0;
                    end else if (y_timer < 2) begin
                        y_timer <= y_timer + 1;
                    end else begin
                        // Timeout - set g permanently low
                        g <= 0;
                    end
                end
            end
        endcase
    end
end

endmodule