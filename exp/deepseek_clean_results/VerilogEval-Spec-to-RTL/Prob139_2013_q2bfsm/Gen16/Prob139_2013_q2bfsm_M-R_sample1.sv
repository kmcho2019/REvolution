module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam RESET      = 2'b00;
localparam PULSE_F    = 2'b01;
localparam WAIT_PATTERN = 2'b10;
localparam CHECK_Y    = 2'b11;

reg [1:0] state, next_state;
reg [2:0] x_shift;
reg [1:0] timeout;
reg f_reg, g_reg;
reg g_permanent;

// State transition logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        x_shift <= 3'b0;
        timeout <= 2'b0;
        g_permanent <= 1'b0;
    end else begin
        state <= next_state;
        x_shift <= {x_shift[1:0], x};  // Shift register for pattern detection
        
        // Timeout counter
        if (state == CHECK_Y && !g_permanent && timeout > 0)
            timeout <= timeout - 1;
    end
end

// Next state logic
always @(*) begin
    case (state)
        RESET: next_state = PULSE_F;
        PULSE_F: next_state = WAIT_PATTERN;
        WAIT_PATTERN: 
            if (x_shift == 3'b101) 
                next_state = CHECK_Y;
            else 
                next_state = WAIT_PATTERN;
        CHECK_Y: 
            if (g_permanent) 
                next_state = CHECK_Y;
            else if (y || timeout == 0) 
                next_state = CHECK_Y;
            else 
                next_state = CHECK_Y;
        default: next_state = RESET;
    endcase
end

// Output logic
always @(posedge clk) begin
    if (!resetn) begin
        f_reg <= 1'b0;
        g_reg <= 1'b0;
    end else begin
        // f output (single pulse)
        if (state == PULSE_F)
            f_reg <= 1'b1;
        else
            f_reg <= 1'b0;
            
        // g output control
        if (state == WAIT_PATTERN && x_shift == 3'b101) begin
            g_reg <= 1'b1;
            timeout <= 2'b10;  // Initialize timeout counter
        end
        else if (state == CHECK_Y && !g_permanent) begin
            if (y) begin
                g_permanent <= 1'b1;
            end
            else if (timeout == 0) begin
                g_reg <= 1'b0;
                g_permanent <= 1'b1;
            end
        end
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule