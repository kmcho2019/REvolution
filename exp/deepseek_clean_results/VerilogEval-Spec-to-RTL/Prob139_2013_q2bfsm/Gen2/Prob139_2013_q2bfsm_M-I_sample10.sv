module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
typedef enum {
    STATE_A,  // Reset state
    STATE_B,  // Pulse f
    STATE_C,  // Monitor x for 1-0-1
    STATE_D,  // Sequence detected, set g
    STATE_E   // Check y within 2 cycles
} state_t;

reg [2:0] state, next_state;
reg [2:0] x_shift;      // 3-bit shift register for x sequence
reg [1:0] timeout_cnt;   // 2-bit timeout counter

// State transition and sequence tracking
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_shift <= 3'b000;
        timeout_cnt <= 2'b00;
    end
    else begin
        state <= next_state;
        x_shift <= {x_shift[1:0], x};  // Shift in new x value
        
        // Update timeout counter in STATE_E
        if (state == STATE_E && !y && timeout_cnt < 2)
            timeout_cnt <= timeout_cnt + 1;
        else if (state != STATE_E)
            timeout_cnt <= 2'b00;
    end
end

// Next state logic
always @(*) begin
    case (state)
        STATE_A: next_state = resetn ? STATE_B : STATE_A;
        
        STATE_B: next_state = STATE_C;
        
        STATE_C: begin
            if (x_shift == 3'b101)  // Detected 1-0-1 sequence
                next_state = STATE_D;
            else
                next_state = STATE_C;
        end
        
        STATE_D: next_state = STATE_E;
        
        STATE_E: begin
            if (y || timeout_cnt == 2)
                next_state = STATE_E;  // Stay permanently
            else
                next_state = STATE_E;  // Continue waiting
        end
        
        default: next_state = STATE_A;
    endcase
end

// Output logic
always @(posedge clk) begin
    if (!resetn) begin
        f <= 0;
        g <= 0;
    end
    else begin
        // f pulses for one cycle after reset
        f <= (state == STATE_B);
        
        // g logic
        if (state == STATE_D)
            g <= 1;
        else if (state == STATE_E && timeout_cnt == 2 && !y)
            g <= 0;
    end
end

endmodule