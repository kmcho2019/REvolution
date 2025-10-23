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

    // Define states
    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    
    reg [1:0] state, next_state;
    reg prev_walk_state;  // 0 for left, 1 for right
    
    // State transition logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    next_state = prev_walk_state ? WALK_RIGHT : WALK_LEFT;
                end else begin
                    next_state = FALLING;
                end
            end
            default: next_state = WALK_LEFT;
        endcase
    end
    
    // State register and prev_walk_state update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            prev_walk_state <= 0;
        end else begin
            state <= next_state;
            // Update previous walk state when not falling
            if (state != FALLING) begin
                prev_walk_state <= (state == WALK_RIGHT);
            end
        end
    end
    
    // Output logic (Moore)
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALLING);

endmodule