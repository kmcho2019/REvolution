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

    // States
    parameter WALK = 1'b0;
    parameter FALL = 1'b1;
    
    reg state, next_state;
    reg direction, next_direction;  // 0=left, 1=right
    
    // State transition logic
    always @(*) begin
        next_state = state;
        next_direction = direction;
        
        case (state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                end
                else begin
                    // Only change direction if not falling
                    if (!direction && bump_left)
                        next_direction = 1'b1;
                    else if (direction && bump_right)
                        next_direction = 1'b0;
                end
            end
            FALL: begin
                if (ground)
                    next_state = WALK;
            end
        endcase
    end
    
    // State and direction registers with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0;  // Start walking left
        end
        else begin
            state <= next_state;
            // Clock gating: only update direction in WALK state with ground
            if (state == WALK && ground)
                direction <= next_direction;
        end
    end
    
    // Output logic - Moore style
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);

endmodule