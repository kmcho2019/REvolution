module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states
enum logic [2:0] {
    WALK_LEFT = 3'b001,
    WALK_RIGHT = 3'b010,
    FALLING = 3'b011,
    DIGGING_LEFT = 3'b100,
    DIGGING_RIGHT = 3'b101,
    SPLATTERED = 3'b110
} state, next_state;

// Define the counter for falling
logic [5:0] fall_counter;
logic [5:0] next_fall_counter;

// Define the direction of the Lemming
logic walk_direction;
logic next_walk_direction;

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_counter <= 0;
        walk_direction <= 1'b0; // 0 for left, 1 for right
    end else begin
        state <= next_state;
        fall_counter <= next_fall_counter;
        walk_direction <= next_walk_direction;
    end
end

// Next state logic
always_comb begin
    next_state = state;
    next_fall_counter = fall_counter;
    next_walk_direction = walk_direction;

    case (state)
        WALK_LEFT: begin
            if (dig && ground) begin
                next_state = DIGGING_LEFT;
            end else if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
                next_walk_direction = 1'b1;
            end else if (bump_right) begin
                // No change
            end
        end
        WALK_RIGHT: begin
            if (dig && ground) begin
                next_state = DIGGING_RIGHT;
            end else if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
                next_walk_direction = 1'b0;
            end else if (bump_left) begin
                // No change
            end
        end
        FALLING: begin
            next_fall_counter = fall_counter + 1;
            if (ground) begin
                if (fall_counter > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = walk_direction ? WALK_RIGHT : WALK_LEFT;
                end
            end
        end
        DIGGING_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
            end
        end
        DIGGING_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 1;
            end
        end
        SPLATTERED: begin
            // No change
        end
    endcase
end

// Output logic
always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
        end
        FALLING: begin
            aaah = 1'b1;
        end
        DIGGING_LEFT: begin
            walk_left = 1'b1;
            digging = 1'b1;
        end
        DIGGING_RIGHT: begin
            walk_right = 1'b1;
            digging = 1'b1;
        end
        SPLATTERED: begin
            // No outputs
        end
    endcase
end

endmodule