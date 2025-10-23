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
reg y_timeout;

always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_history <= 0;
        y_timeout <= 0;
    end
    else begin
        case (state)
            RESET: begin
                state <= F_PULSE;
                f <= 1;
            end
            
            F_PULSE: begin
                f <= 0;
                state <= WAIT_PATTERN;
            end
            
            WAIT_PATTERN: begin
                x_history <= {x_history[0], x};
                if (x_history == 2'b01 && x == 1'b1) begin
                    g <= 1;
                    state <= MONITOR_Y;
                    y_timeout <= 0;
                end
            end
            
            MONITOR_Y: begin
                if (y) begin
                    // g remains 1 permanently
                end
                else if (!y_timeout) begin
                    y_timeout <= 1;
                end
                else begin
                    g <= 0;
                    // g remains 0 permanently
                end
            end
        endcase
    end
end

endmodule