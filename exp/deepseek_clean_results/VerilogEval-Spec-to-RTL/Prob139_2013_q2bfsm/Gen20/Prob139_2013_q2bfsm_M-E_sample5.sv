module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [1:0] state;
reg [2:0] x_pattern;
reg [1:0] y_timeout;
reg g_reg;

localparam S_RESET    = 2'b00;
localparam S_PULSE_F  = 2'b01;
localparam S_WAIT_X   = 2'b10;
localparam S_WAIT_Y   = 2'b11;

// State machine
always @(posedge clk) begin
    if (!resetn) begin
        state <= S_RESET;
        x_pattern <= 3'b000;
        y_timeout <= 2'b00;
        g_reg <= 1'b0;
    end else begin
        // Shift x into pattern register
        x_pattern <= {x_pattern[1:0], x};
        
        case (state)
            S_RESET: begin
                state <= S_PULSE_F;
                g_reg <= 1'b0;
            end
            
            S_PULSE_F: begin
                state <= S_WAIT_X;
            end
            
            S_WAIT_X: begin
                if (x_pattern == 3'b101) begin
                    state <= S_WAIT_Y;
                    y_timeout <= 2'b00;
                end
            end
            
            S_WAIT_Y: begin
                if (y) begin
                    // Stay in this state permanently with g=1
                    g_reg <= 1'b1;
                end else if (y_timeout == 2'b10) begin
                    // Timeout reached, go to permanent g=0
                    g_reg <= 1'b0;
                end else begin
                    y_timeout <= y_timeout + 1;
                end
            end
        endcase
    end
end

// Output assignments
assign f = (state == S_PULSE_F);
assign g = (state == S_WAIT_Y) ? (y ? 1'b1 : (y_timeout == 2'b10) ? 1'b0 : g_reg) : g_reg;

endmodule