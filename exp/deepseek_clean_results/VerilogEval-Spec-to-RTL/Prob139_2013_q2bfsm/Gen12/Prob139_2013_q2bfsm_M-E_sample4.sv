module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
localparam INIT        = 2'b00;
localparam PATTERN_WAIT = 2'b01;
localparam MONITOR     = 2'b10;

reg [1:0] state;
reg [2:0] x_pattern;
reg [1:0] timeout_counter;
reg g_permanent;

// Pattern matcher for "101"
wire pattern_match = (x_pattern == 3'b101);

always @(posedge clk) begin
    if (!resetn) begin
        state <= INIT;
        f <= 0;
        g <= 0;
        x_pattern <= 0;
        timeout_counter <= 0;
        g_permanent <= 0;
    end
    else begin
        // Update x pattern history
        x_pattern <= {x_pattern[1:0], x};
        
        case (state)
            INIT: begin
                f <= 1;
                g <= 0;
                state <= PATTERN_WAIT;
                g_permanent <= 0;
            end
            
            PATTERN_WAIT: begin
                f <= 0;
                if (pattern_match && !g_permanent) begin
                    g <= 1;
                    state <= MONITOR;
                    timeout_counter <= 0;
                end
            end
            
            MONITOR: begin
                if (y) begin
                    g_permanent <= 1;  // g stays 1 forever
                end
                else if (timeout_counter == 2'b01) begin
                    g <= 0;
                    g_permanent <= 1;  // g stays 0 forever
                end
                else begin
                    timeout_counter <= timeout_counter + 1;
                end
            end
        endcase
    end
end

endmodule