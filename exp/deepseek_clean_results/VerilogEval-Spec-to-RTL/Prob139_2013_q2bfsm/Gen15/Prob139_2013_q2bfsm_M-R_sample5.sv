module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam RESET     = 3'd0;
localparam F_PULSE   = 3'd1;
localparam DETECT    = 3'd2;
localparam MONITOR_Y = 3'd3;
localparam G_HIGH    = 3'd4;
localparam G_LOW     = 3'd5;

reg [2:0] current_state, next_state;
reg [2:0] x_history;
reg [1:0] y_timer;
wire pattern_match;

// Sequential state transition
always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        current_state <= RESET;
        x_history <= 3'b0;
        y_timer <= 2'b0;
    end else begin
        current_state <= next_state;
        
        // Update x history shift register
        if (current_state == DETECT)
            x_history <= {x_history[1:0], x};
            
        // Update y timer
        if (current_state == MONITOR_Y && y_timer < 2'b10)
            y_timer <= y_timer + 1;
        else if (current_state != MONITOR_Y)
            y_timer <= 2'b0;
    end
end

// Combinational next state logic
always @(*) begin
    next_state = current_state;
    
    case (current_state)
        RESET:     next_state = F_PULSE;
        F_PULSE:   next_state = DETECT;
        DETECT:    if (pattern_match) next_state = MONITOR_Y;
        MONITOR_Y: begin
            if (y)
                next_state = G_HIGH;
            else if (y_timer == 2'b01)  // After 2 cycles (0 and 1)
                next_state = G_LOW;
        end
        // G_HIGH and G_LOW are terminal states
    endcase
end

// Pattern detection
assign pattern_match = (x_history == 3'b101);

// Output assignments
assign f = (current_state == F_PULSE);
assign g = (current_state == G_HIGH) || 
           (current_state == MONITOR_Y && pattern_match);

endmodule