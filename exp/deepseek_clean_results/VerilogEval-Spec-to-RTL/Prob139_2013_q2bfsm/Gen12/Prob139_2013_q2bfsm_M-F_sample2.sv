module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding (3 bits to handle all states)
localparam STATE_RESET   = 3'd0;
localparam STATE_F_PULSE = 3'd1;
localparam STATE_WAIT_X  = 3'd2;
localparam STATE_WAIT_Y  = 3'd3;
localparam STATE_PERM    = 3'd4;

reg [2:0] state, next_state;
reg [2:0] x_shift;      // 3-bit shift register for sequence detection
reg timeout_counter;     // 1-bit counter for 2-cycle timeout

// State transition logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_RESET;
        x_shift <= 3'b000;
        timeout_counter <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        
        // Update x shift register every cycle
        x_shift <= {x_shift[1:0], x};
        
        // Timeout counter logic
        if (state == STATE_WAIT_Y) begin
            timeout_counter <= timeout_counter + 1;
        end else begin
            timeout_counter <= 0;
        end
        
        // Output logic
        case (state)
            STATE_F_PULSE: begin
                f <= 1;
                g <= 0;
            end
            STATE_WAIT_X: begin
                f <= 0;
                g <= 0;
            end
            STATE_WAIT_Y: begin
                f <= 0;
                g <= 1;  // g=1 while waiting for y
            end
            STATE_PERM: begin
                f <= 0;
                // g maintains its value permanently
            end
            default: begin
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case (state)
        STATE_RESET: 
            if (resetn) next_state = STATE_F_PULSE;
            
        STATE_F_PULSE: 
            next_state = STATE_WAIT_X;
            
        STATE_WAIT_X: 
            if (x_shift == 3'b101)  // Detected 1-0-1 sequence
                next_state = STATE_WAIT_Y;
                
        STATE_WAIT_Y: 
            if (y) 
                next_state = STATE_PERM;
            else if (timeout_counter)  // After 2 cycles (count=1)
                next_state = STATE_PERM;
                
        STATE_PERM: 
            next_state = STATE_PERM;  // Permanent state until reset
    endcase
end

endmodule