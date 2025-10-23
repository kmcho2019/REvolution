module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Enum for states
enum {LEFT, RIGHT, FALLING} state, next_state;

// Variable to store previous walking direction
reg walk_dir;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset state to walking left
        state <= LEFT;
        walk_dir <= 1'b0; // Not walking right
    end else begin
        // Update state
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        LEFT: begin
            // Bump left or right will switch direction
            if (bump_left) next_state = RIGHT;
            else if (bump_right) next_state = RIGHT;
            else if (!ground) next_state = FALLING;
            else next_state = LEFT;
        end
        RIGHT: begin
            // Bump left or right will switch direction
            if (bump_left) next_state = LEFT;
            else if (bump_right) next_state = LEFT;
            else if (!ground) next_state = FALLING;
            else next_state = RIGHT;
        end
        FALLING: begin
            // When ground reappears, resume walking in previous direction
            if (ground) begin
                if (walk_dir) next_state = RIGHT;
                else next_state = LEFT;
            end else next_state = FALLING;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset walk_dir
        walk_dir <= 1'b0; // Not walking right
    end else if (state == LEFT &&!ground) begin
        // Store walking direction when falling
        walk_dir <= 1'b0; // Walking left
    end else if (state == RIGHT &&!ground) begin
        // Store walking direction when falling
        walk_dir <= 1'b1; // Walking right
    end
end

// Output logic
always @(*) begin
    case (state)
        LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

endmodule