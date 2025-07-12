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
    parameter WALK_LEFT  = 3'b0001;
    parameter WALK_RIGHT = 3'b0010;
    parameter FALL       = 3'b0100;
    parameter DIG_LEFT   = 3'b1000;
    parameter DIG_RIGHT  = 3'b1001; // LSB indicates original direction

    reg [3:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground)          next_state = FALL;
                else if (dig)        next_state = DIG_LEFT;
                else if (bump_left)   next_state = WALK_RIGHT;
                else                 next_state = WALK_LEFT;
            end
            
            WALK_RIGHT: begin
                if (!ground)          next_state = FALL;
                else if (dig)        next_state = DIG_RIGHT;
                else if (bump_right)  next_state = WALK_LEFT;
                else                 next_state = WALK_RIGHT;
            end
            
            FALL: begin
                if (ground) begin
                    if (state[0])     next_state = WALK_RIGHT;
                    else             next_state = WALK_LEFT;
                end
                else                 next_state = FALL;
            end
            
            DIG_LEFT, DIG_RIGHT: begin
                if (!ground)        next_state = FALL;
                else                 next_state = state;
            end
            
            default:                 next_state = WALK_LEFT;
        endcase
    end

    // State register
    always @(posedge clk, posedge areset) begin
        if (areset) state <= WALK_LEFT;
        else       state <= next_state;
    end

    // Output logic - direct from state bits
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL);
    assign digging    = (state[3]); // DIG_LEFT or DIG_RIGHT

endmodule