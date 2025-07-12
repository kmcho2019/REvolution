module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // One-hot state encoding
    parameter WALK_LEFT  = 5'b00001;
    parameter WALK_RIGHT = 5'b00010;
    parameter FALLING    = 5'b00100;
    parameter DIGGING    = 5'b01000;
    parameter SPLATTERED = 5'b10000;
    
    reg [4:0] state, next_state;
    reg [4:0] fall_counter;
    reg saved_direction;  // 0=right, 1=left
    
    // State transition logic
    always @(*) begin
        next_state = state;  // Default: stay in current state
        
        case (1'b1)  // Synthesis will optimize this case statement
            state[0]: begin  // WALK_LEFT
                if (!ground)
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else if (bump_left)
                    next_state = WALK_RIGHT;
            end
            
            state[1]: begin  // WALK_RIGHT
                if (!ground)
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else if (bump_right)
                    next_state = WALK_LEFT;
            end
            
            state[2]: begin  // FALLING
                if (ground) begin
                    if (fall_counter > 5'd20)
                        next_state = SPLATTERED;
                    else
                        next_state = saved_direction ? WALK_LEFT : WALK_RIGHT;
                end
            end
            
            state[3]: begin  // DIGGING
                if (!ground)
                    next_state = FALLING;
            end
            
            // SPLATTERED stays in same state
            default: next_state = WALK_LEFT;
        endcase
    end
    
    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            saved_direction <= 1'b1;  // Start walking left
            fall_counter <= 5'b0;
        end else begin
            state <= next_state;
            
            // Save direction when leaving walking states
            if ((state[0] || state[1]) && (next_state[2] || next_state[3])) begin
                saved_direction <= state[0];
            end
            
            // Update fall counter
            if (state[2]) begin  // FALLING
                fall_counter <= (!ground) ? fall_counter + 1 : 5'b0;
            end else begin
                fall_counter <= 5'b0;
            end
        end
    end
    
    // Output logic - simple decoding from state
    assign walk_left  = state[0] && !state[4];  // WALK_LEFT and not SPLATTERED
    assign walk_right = state[1] && !state[4];  // WALK_RIGHT and not SPLATTERED
    assign aaah       = state[2];               // FALLING
    assign digging    = state[3];               // DIGGING
    
endmodule