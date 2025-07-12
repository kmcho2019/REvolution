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
    reg direction, next_direction; // 0=left, 1=right
    
    // State and direction transition
    always @(*) begin
        case (state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                    next_direction = direction; // Remember current direction
                end else begin
                    next_state = WALK;
                    // Handle bumps only when walking on ground
                    if (bump_left) next_direction = 1'b1;
                    else if (bump_right) next_direction = 1'b0;
                    else next_direction = direction;
                end
            end
            FALL: begin
                if (ground) begin
                    next_state = WALK;
                    next_direction = direction; // Keep same direction
                end else begin
                    next_state = FALL;
                    next_direction = direction; // Direction unchanged during fall
                end
            end
        endcase
    end
    
    // Registers with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // Start walking left
        end else begin
            state <= next_state;
            direction <= next_direction;
        end
    end
    
    // Output logic
    assign walk_left = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah = (state == FALL);
    
endmodule