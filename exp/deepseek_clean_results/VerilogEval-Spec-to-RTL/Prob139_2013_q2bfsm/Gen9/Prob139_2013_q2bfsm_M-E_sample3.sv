module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
localparam IDLE  = 2'b00;
localparam DETECT = 2'b01;
localparam FINAL = 2'b10;

reg [1:0] state;
reg [2:0] x_pattern;
reg [1:0] y_timeout;
reg g_permanent;

always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        f <= 0;
        g <= 0;
        x_pattern <= 0;
        y_timeout <= 0;
        g_permanent <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                f <= 1;
                g <= 0;
                x_pattern <= 0;
                state <= DETECT;
            end
            
            DETECT: begin
                f <= 0;
                // Shift in new x value
                x_pattern <= {x_pattern[1:0], x};
                
                // Check for 101 pattern
                if (x_pattern == 3'b101) begin
                    g <= 1;
                    y_timeout <= 0;
                    state <= FINAL;
                end
            end
            
            FINAL: begin
                if (!g_permanent) begin
                    if (y) begin
                        g_permanent <= 1;
                    end
                    else if (y_timeout < 2'b10) begin
                        y_timeout <= y_timeout + 1;
                    end
                    else begin
                        g <= 0;
                        g_permanent <= 1;
                    end
                end
            end
        endcase
    end
end

endmodule