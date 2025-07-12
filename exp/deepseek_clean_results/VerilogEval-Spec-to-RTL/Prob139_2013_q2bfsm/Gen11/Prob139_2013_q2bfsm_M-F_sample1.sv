module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam STATE_A = 2'd0;  // Reset state
localparam STATE_B = 2'd1;  // f=1 pulse state
localparam STATE_C = 2'd2;  // Monitoring x sequence
localparam STATE_D = 2'd3;  // Monitoring y with timeout
localparam STATE_E = 3'd4;  // Permanent state (needs extra bit)

reg [2:0] state, next_state;  // Need 3 bits for STATE_E
reg [2:0] x_history;          // 3-bit shift register for sequence detection
reg timeout_flag;             // Indicates timeout occurred
reg g_reg;                    // Permanent g value storage

// State transition logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_history <= 3'b000;
        timeout_flag <= 0;
        g_reg <= 0;
    end else begin
        state <= next_state;
        
        // Update x history shift register
        x_history <= {x_history[1:0], x};
        
        // Set timeout flag after 2 cycles in STATE_D
        if (state == STATE_D && next_state == STATE_D) begin
            if (x_history[1:0] == 2'b11)  // Counts cycles (first cycle: 01, second: 11)
                timeout_flag <= 1;
        end else begin
            timeout_flag <= 0;
        end
        
        // Set permanent g value when entering STATE_E
        if (next_state == STATE_E) begin
            g_reg <= (y || !timeout_flag);  // g=1 if y was 1 or timeout didn't occur
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
            if (x_history == 3'b101)  // Detect 1-0-1 sequence
                next_state = STATE_D;
        end
        STATE_D: begin
            if (y)
                next_state = STATE_E;
            else if (timeout_flag)
                next_state = STATE_E;
        end
        STATE_E: next_state = STATE_E;  // Permanent state
    endcase
end

// Output logic
assign f = (state == STATE_B);
assign g = (state == STATE_E) ? g_reg : (state == STATE_D && y);

endmodule