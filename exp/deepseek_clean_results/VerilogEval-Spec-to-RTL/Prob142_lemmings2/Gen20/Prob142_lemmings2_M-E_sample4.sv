module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State encoding (one-hot)
    localparam WALK_LEFT  = 2'b01;
    localparam WALK_RIGHT = 2'b10;
    localparam FALLING    = 2'b00;
    
    reg [1:0] state, next_state;
    reg ground_prev;
    
    // Edge detection for ground signal
    wire ground_falling_edge = ground_prev & ~ground;
    wire ground_rising_edge = ~ground_prev & ground;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            ground_prev <= 1;
        end else begin
            state <= next_state;
            ground_prev <= ground;
        end
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (ground_falling_edge)
                    next_state = FALLING;
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (ground_falling_edge)
                    next_state = FALLING;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            FALLING: begin
                if (ground_rising_edge) begin
                    // Return to previous walking direction
                    if (ground_prev)
                        next_state = (bump_left) ? WALK_RIGHT : WALK_LEFT;
                    else
                        next_state = (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
                end else
                    next_state = FALLING;
            end
            default: next_state = WALK_LEFT;
        endcase
    end
    
    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALLING);

endmodule