module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding (3 bits to safely include STATE_E)
localparam STATE_A = 3'd0;  // Reset state
localparam STATE_B = 3'd1;  // f=1 pulse state
localparam STATE_C = 3'd2;  // Monitoring x sequence
localparam STATE_D = 3'd3;  // Monitoring y with timeout
localparam STATE_E = 3'd4;  // Permanent state

reg [2:0] state, next_state;
reg [1:0] x_history;
reg [1:0] timeout_counter;  // Counts 0-1-2 for 2-cycle timeout
reg g_reg;

// State transition logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_history <= 2'b00;
        timeout_counter <= 2'b00;
        g_reg <= 0;
    end else begin
        state <= next_state;
        
        // Update x history in STATE_C
        if (state == STATE_C)
            x_history <= {x_history[0], x};
            
        // Handle timeout counter
        if (state == STATE_D) begin
            if (timeout_counter < 2'd2)
                timeout_counter <= timeout_counter + 1;
        end else begin
            timeout_counter <= 2'b00;
        end
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case (state)
        STATE_A: if (resetn) next_state = STATE_B;
        STATE_B: next_state = STATE_C;
        STATE_C: begin
            if (x_history == 2'b01 && x == 1'b1)
                next_state = STATE_D;
        end
        STATE_D: begin
            if (y)
                next_state = STATE_E;
            else if (timeout_counter == 2'd1)  // After 2 cycles (0,1)
                next_state = STATE_E;
        end
        STATE_E: next_state = STATE_E;  // Stay until reset
    endcase
end

// Output logic
always @(posedge clk) begin
    if (!resetn) begin
        g_reg <= 0;
    end else if (next_state == STATE_E) begin
        g_reg <= (state == STATE_D && y);  // Set g permanently based on y
    end
end

assign f = (state == STATE_B);
assign g = (state == STATE_E) ? g_reg : (state == STATE_D && y);

endmodule