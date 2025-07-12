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
    parameter WALKING = 1'b0;
    parameter FALLING = 1'b1;
    
    reg state, next_state;
    reg direction, next_direction; // 0=left, 1=right
    
    // State and direction transition logic
    always @(*) begin
        next_state = state;
        next_direction = direction;
        
        case (state)
            WALKING: begin
                if (!ground) begin
                    next_state = FALLING;
                end
                else if (bump_left) begin
                    next_direction = 1'b1; // switch to right
                end
                else if (bump_right) begin
                    next_direction = 1'b0; // switch to left
                end
            end
            FALLING: begin
                if (ground) begin
                    next_state = WALKING;
                end
            end
        endcase
    end
    
    // State and direction registers with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALKING;
            direction <= 1'b0; // start walking left
        end
        else begin
            state <= next_state;
            direction <= next_direction;
        end
    end
    
    // Output logic
    assign walk_left = (state == WALKING) & ~direction;
    assign walk_right = (state == WALKING) & direction;
    assign aaah = (state == FALLING);

endmodule