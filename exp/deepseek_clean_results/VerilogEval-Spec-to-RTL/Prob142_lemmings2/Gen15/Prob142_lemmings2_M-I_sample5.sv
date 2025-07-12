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
        case (state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                    next_direction = direction;
                end
                else begin
                    next_state = WALK;
                    // Simplified direction toggle logic
                    if (direction) begin
                        next_direction = bump_right ? ~direction : direction;
                    end
                    else begin
                        next_direction = bump_left ? ~direction : direction;
                    end
                end
            end
            FALL: begin
                next_state = ground ? WALK : FALL;
                next_direction = direction;
            end
            default: begin
                next_state = WALK;
                next_direction = 0;
            end
        endcase
    end
    
    // State and direction registers with async reset and precise clock gating
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
        end
        else begin
            state <= next_state;
            // Only update direction when in WALK state and ground is present
            if (state == WALK && ground)
                direction <= next_direction;
        end
    end
    
    // Output logic - Moore style
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);

endmodule