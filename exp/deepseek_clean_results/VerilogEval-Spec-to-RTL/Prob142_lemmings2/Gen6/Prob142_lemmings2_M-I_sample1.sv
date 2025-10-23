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
    
    // State transition logic (simplified)
    always @(*) begin
        case (state)
            WALK: next_state = (!ground) ? FALL : WALK;
            FALL: next_state = (ground) ? WALK : FALL;
        endcase
    end
    
    // Direction logic (separate to reduce critical path)
    always @(*) begin
        if (state == WALK && ground) begin
            if ((!direction && bump_left) || (direction && bump_right))
                next_direction = ~direction;
            else
                next_direction = direction;
        end
        else begin
            next_direction = direction;  // Maintain direction when falling
        end
    end
    
    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
        end
        else begin
            state <= next_state;
        end
    end
    
    // Direction register with async reset and clock gating
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;  // Start walking left
        end
        else if (state == WALK && ground) begin  // Only update when walking on ground
            direction <= next_direction;
        end
    end
    
    // Output logic (unchanged but efficient)
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);

endmodule