module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam STATE_A = 3'b000;  // Reset state
localparam STATE_B = 3'b001;  // f=1 pulse state
localparam STATE_C = 3'b010;  // Waiting for x sequence
localparam STATE_D = 3'b011;  // g=1, monitoring y
localparam STATE_E = 3'b100;  // g=1 permanently
localparam STATE_F = 3'b101;  // g=0 permanently

reg [2:0] state, next_state;
reg [2:0] x_history;     // 3-bit shift register for x sequence
reg [1:0] timeout_cnt;   // 2-bit counter for y timeout

// Continuous assignments for outputs
assign f = (state == STATE_B);
assign g = (state == STATE_D || state == STATE_E);

// State transition logic
always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        state <= STATE_A;
        x_history <= 3'b000;
        timeout_cnt <= 2'b00;
    end else begin
        state <= next_state;
        x_history <= {x_history[1:0], x};  // Shift in new x value
        
        // Update timeout counter only in STATE_D
        if (state == STATE_D)
            timeout_cnt <= timeout_cnt + 1;
        else
            timeout_cnt <= 2'b00;
    end
end

// Next state logic
always @(*) begin
    case (state)
        STATE_A: next_state = STATE_B;  // Always transition to B after reset
        
        STATE_B: next_state = STATE_C;  // Single cycle in B then to C
        
        STATE_C: begin
            // Check for 1,0,1 sequence (MSB is oldest)
            if (x_history == 3'b101)
                next_state = STATE_D;
            else
                next_state = STATE_C;
        end
        
        STATE_D: begin
            if (y)
                next_state = STATE_E;
            else if (timeout_cnt == 2'b10)  // After 2 cycles (0->1->2)
                next_state = STATE_F;
            else
                next_state = STATE_D;
        end
        
        // Permanent states
        STATE_E: next_state = STATE_E;
        STATE_F: next_state = STATE_F;
        
        default: next_state = STATE_A;
    endcase
end

endmodule