module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Pattern detection registers
reg [2:0] x_shift;
wire pattern_match = (x_shift == 3'b101);

// Control signals
reg f_pulse;
reg pattern_found;
reg [1:0] timeout_counter;
reg g_permanent;

// State encoding
localparam IDLE = 0;
localparam MONITOR_Y = 1;
reg state;

// Pattern detection shift register
always @(posedge clk) begin
    if (!resetn) begin
        x_shift <= 3'b0;
    end else begin
        x_shift <= {x_shift[1:0], x};
    end
end

// FSM control logic
always @(posedge clk) begin
    if (!resetn) begin
        f_pulse <= 1'b0;
        pattern_found <= 1'b0;
        timeout_counter <= 2'b0;
        g_permanent <= 1'b0;
        state <= IDLE;
    end else begin
        // Default assignments
        f_pulse <= 1'b0;
        
        // State transitions
        case (state)
            IDLE: begin
                if (resetn && !f_pulse) begin
                    f_pulse <= 1'b1;  // Initial pulse
                end
                
                if (pattern_match) begin
                    pattern_found <= 1'b1;
                    state <= MONITOR_Y;
                    timeout_counter <= 2'b0;
                end
            end
            
            MONITOR_Y: begin
                if (y) begin
                    g_permanent <= 1'b1;
                    state <= IDLE;
                end else if (timeout_counter == 2'b10) begin
                    g_permanent <= 1'b0;
                    state <= IDLE;
                end
                timeout_counter <= timeout_counter + 1;
            end
        endcase
    end
end

// Output assignments
assign f = f_pulse;
assign g = (pattern_found && (state == MONITOR_Y)) || g_permanent;

endmodule