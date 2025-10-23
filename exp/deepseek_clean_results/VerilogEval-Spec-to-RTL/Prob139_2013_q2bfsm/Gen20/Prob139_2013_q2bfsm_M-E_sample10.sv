module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
reg [2:0] x_pattern;
reg [1:0] y_timer;
reg f_pulsed;

localparam IDLE      = 2'b00;
localparam DETECT    = 2'b01;
localparam MONITOR   = 2'b10;

always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        f <= 0;
        g <= 0;
        x_pattern <= 0;
        y_timer <= 0;
        f_pulsed <= 0;
    end else begin
        case (state)
            IDLE: begin
                // Pulse f for one cycle after reset
                if (!f_pulsed) begin
                    f <= 1;
                    f_pulsed <= 1;
                end else begin
                    f <= 0;
                    state <= DETECT;
                end
                x_pattern <= {x_pattern[1:0], x};
            end
            
            DETECT: begin
                f <= 0;
                x_pattern <= {x_pattern[1:0], x};
                
                // Detect 101 pattern
                if (x_pattern == 3'b101) begin
                    g <= 1;
                    state <= MONITOR;
                    y_timer <= 0;
                end
            end
            
            MONITOR: begin
                // Permanent states - only exit on reset
                if (y) begin
                    // Maintain g=1 permanently
                    g <= 1;
                end else if (y_timer < 2'b10) begin
                    // Count cycles until timeout
                    y_timer <= y_timer + 1;
                end else begin
                    // Timeout reached - set g=0 permanently
                    g <= 0;
                end
            end
        endcase
    end
end

endmodule