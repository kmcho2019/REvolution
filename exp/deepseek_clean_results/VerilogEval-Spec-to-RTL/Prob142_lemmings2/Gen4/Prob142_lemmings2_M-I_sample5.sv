module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
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
                    next_direction = direction;  // Maintain direction
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
                next_direction = direction;  // Direction remains unchanged
            end
            default: begin
                next_state = WALK;
                next_direction = 0;
            end
        endcase
    end
    
    // State and direction registers with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;  // Start walking left
        end
        else begin
            state <= next_state;
            // Update direction only when in WALK state and ground is high
            if (state == WALK && ground)
                direction <= next_direction;
        end
    end
    
    // Registered output logic - Moore style
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
        end
        else begin
            walk_left <= (next_state == WALK) && !next_direction;
            walk_right <= (next_state == WALK) && next_direction;
            aaah <= (next_state == FALL);
        end
    end

endmodule