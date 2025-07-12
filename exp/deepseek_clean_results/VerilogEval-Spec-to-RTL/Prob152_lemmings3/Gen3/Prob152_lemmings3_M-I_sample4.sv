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
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING    = 2'b10;
    localparam DIGGING    = 2'b11;
    
    reg [1:0] state, next_state;

    // Next state logic (parallel evaluation)
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (~ground)
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (~ground)
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            FALLING: begin
                if (ground)
                    next_state = (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
                else
                    next_state = FALLING;
            end
            DIGGING: begin
                if (~ground)
                    next_state = FALLING;
                else
                    next_state = DIGGING;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Output logic (direct from state)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);
    assign digging    = (state == DIGGING);

endmodule