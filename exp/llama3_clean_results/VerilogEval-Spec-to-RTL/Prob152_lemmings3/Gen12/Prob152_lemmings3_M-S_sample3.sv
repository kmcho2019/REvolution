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
    WALK_RIGHT = 2'b10,
    DIGGING = 2'b11
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
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT; // Already walking left, no change
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_LEFT; // Change direction
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = WALK_LEFT; // Default to walking left after falling
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
    endcase
end

// Output logic
always_comb begin
    walk_left = (state == WALK_LEFT)? 1'b1 : 1'b0;
    walk_right = (state == WALK_RIGHT)? 1'b1 : 1'b0;
    aaah = (state == FALLING)? 1'b1 : 1'b0;
    digging = (state == DIGGING)? 1'b1 : 1'b0;
end

endmodule