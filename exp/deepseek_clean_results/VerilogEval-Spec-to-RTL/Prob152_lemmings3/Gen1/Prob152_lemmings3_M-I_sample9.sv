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

    // One-hot encoded states
    parameter WALK_LEFT     = 6'b000001;
    parameter WALK_RIGHT    = 6'b000010;
    parameter FALLING_LEFT  = 6'b000100;
    parameter FALLING_RIGHT = 6'b001000;
    parameter DIGGING_LEFT  = 6'b010000;
    parameter DIGGING_RIGHT = 6'b100000;

    reg [5:0] state, next_state;

    // State transition logic - optimized for timing
    always @(*) begin
        next_state = state;  // Default to current state
        
        case (1'b1)  // Synthesis will optimize this to parallel case
            state[0]: begin  // WALK_LEFT
                if (!ground) begin
                    next_state = FALLING_LEFT;
                end else if (dig) begin
                    next_state = DIGGING_LEFT;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end
            end
            
            state[1]: begin  // WALK_RIGHT
                if (!ground) begin
                    next_state = FALLING_RIGHT;
                end else if (dig) begin
                    next_state = DIGGING_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end
            end
            
            state[2]: begin  // FALLING_LEFT
                if (ground) next_state = WALK_LEFT;
            end
            
            state[3]: begin  // FALLING_RIGHT
                if (ground) next_state = WALK_RIGHT;
            end
            
            state[4]: begin  // DIGGING_LEFT
                if (!ground) next_state = FALLING_LEFT;
            end
            
            state[5]: begin  // DIGGING_RIGHT
                if (!ground) next_state = FALLING_RIGHT;
            end
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Optimized output logic - direct from state bits
    assign walk_left  = state[0];
    assign walk_right = state[1];
    assign aaah       = state[2] | state[3];  // FALLING states
    assign digging    = state[4] | state[5];  // DIGGING states

endmodule