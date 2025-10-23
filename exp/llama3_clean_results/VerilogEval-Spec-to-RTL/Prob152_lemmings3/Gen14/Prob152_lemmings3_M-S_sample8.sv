module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define the states
enum logic [1:0] {
    FALLING = 2'b00,
    WALK_LEFT = 2'b01,
    WALK_RIGHT = 2'b10
} state, next_state;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state
always_comb begin
    next_state = state;
    case (state)
        WALK_LEFT: begin
            if (bump_left) next_state = WALK_RIGHT;
            else if (bump_right) next_state = WALK_RIGHT;
            else if (dig && ground) next_state = WALK_LEFT; // Continue walking left if digging starts
            else if (!ground) next_state = FALLING;
        end
        WALK_RIGHT: begin
            if (bump_right) next_state = WALK_LEFT;
            else if (bump_left) next_state = WALK_LEFT;
            else if (dig && ground) next_state = WALK_RIGHT; // Continue walking right if digging starts
            else if (!ground) next_state = FALLING;
        end
        FALLING: begin
            if (ground) begin
                if (dig) next_state = (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT; // If was walking left or right before falling, resume that
                else next_state = (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT; // Maintain the previous walking direction after falling
            end
        end
    endcase
end

// Output logic
always_comb begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    case (state)
        WALK_LEFT: walk_left = 1'b1;
        WALK_RIGHT: walk_right = 1'b1;
        FALLING: aaah = 1'b1;
    endcase
    // Handle digging output separately as it depends on the dig input and current state
    if (dig && (state == WALK_LEFT || state == WALK_RIGHT)) digging = 1'b1;
end

endmodule