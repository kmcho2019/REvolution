module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding with enough bits (3 bits for 5 states)
localparam STATE_A = 3'd0;  // Reset state
localparam STATE_B = 3'd1;  // f=1 pulse state
localparam STATE_C = 3'd2;  // Monitoring x sequence
localparam STATE_D = 3'd3;  // Monitoring y with timeout
localparam STATE_E = 3'd4;  // Permanent state

reg [2:0] state;
reg [2:0] next_state;
reg [2:0] x_history;  // 3-bit shift register for 1-0-1 detection
reg timeout_flag;     // Tracks if we're in second timeout cycle
reg f_reg, g_reg;

// State transition logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_history <= 3'b000;
        timeout_flag <= 0;
    end else begin
        state <= next_state;
        x_history <= {x_history[1:0], x};  // Shift in new x value
        
        // Update timeout flag in STATE_D
        if (state == STATE_D && !y)
            timeout_flag <= ~timeout_flag;
        else
            timeout_flag <= 0;
    end
end

// Next state logic
always @(*) begin
    case (state)
        STATE_A: next_state = resetn ? STATE_B : STATE_A;
        STATE_B: next_state = STATE_C;
        STATE_C: next_state = (x_history == 3'b101) ? STATE_D : STATE_C;
        STATE_D: begin
            if (y)
                next_state = STATE_E;
            else if (timeout_flag)
                next_state = STATE_E;
            else
                next_state = STATE_D;
        end
        STATE_E: next_state = STATE_E;
        default: next_state = STATE_A;
    endcase
end

// Output logic
always @(posedge clk) begin
    if (!resetn) begin
        f_reg <= 0;
        g_reg <= 0;
    end else begin
        case (state)
            STATE_B: f_reg <= 1;
            default: f_reg <= 0;
        endcase
        
        if (state == STATE_D && y)
            g_reg <= 1;
        else if (state == STATE_D && timeout_flag)
            g_reg <= 0;
        // g_reg maintains value in STATE_E
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule