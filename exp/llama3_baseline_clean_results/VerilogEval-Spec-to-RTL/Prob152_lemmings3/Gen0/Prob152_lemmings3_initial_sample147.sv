module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states
enum logic [1:0] {
    WALK_LEFT,
    WALK_RIGHT,
    DIGGING,
    FALLING
} state, next_state;

// Define the original walking direction
logic [1:0] original_direction;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        original_direction <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (ground == 1'b0) begin
                next_state = FALLING;
                original_direction = WALK_LEFT;
            end else if (dig == 1'b1) begin
                next_state = DIGGING;
                original_direction = WALK_LEFT;
            end else if (bump_left == 1'b1) begin
                next_state = WALK_RIGHT;
            end else if (bump_right == 1'b1) begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (ground == 1'b0) begin
                next_state = FALLING;
                original_direction = WALK_RIGHT;
            end else if (dig == 1'b1) begin
                next_state = DIGGING;
                original_direction = WALK_RIGHT;
            end else if (bump_left == 1'b1) begin
                next_state = WALK_LEFT;
            end else if (bump_right == 1'b1) begin
                next_state = WALK_LEFT;
            end
        end
        DIGGING: begin
            digging = 1'b1;
            if (ground == 1'b0) begin
                next_state = FALLING;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground == 1'b1) begin
                next_state = original_direction;
            end
        end
    endcase
end

endmodule