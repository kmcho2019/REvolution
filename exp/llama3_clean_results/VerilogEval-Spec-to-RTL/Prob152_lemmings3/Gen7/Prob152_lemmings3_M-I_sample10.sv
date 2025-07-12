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

// Define the states using one-hot encoding
enum logic [2:0] {
    FALLING = 3'b001,
    WALKING = 3'b010,
    DIGGING = 3'b100
} state, next_state;

// Define the walking directions
enum logic [0:0] {
    LEFT = 1'b0,
    RIGHT = 1'b1
} walk_direction, next_walk_direction;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_direction <= LEFT;
    end else begin
        state <= next_state;
        walk_direction <= next_walk_direction;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    next_walk_direction = walk_direction;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        WALKING: begin
            if (walk_direction == LEFT) begin
                walk_left = 1'b1;
            end else begin
                walk_right = 1'b1;
            end

            if (!ground) begin
                next_state = FALLING;
            end else if (dig && ground) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_walk_direction = RIGHT;
            end else if (bump_right) begin
                next_walk_direction = LEFT;
            end
        end

        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                next_state = WALKING;
            end
        end

        DIGGING: begin
            digging = 1'b1;
            if (!ground) begin
                next_state = FALLING;
            end
        end

        default: begin
            next_state = WALKING;
        end
    endcase
end

endmodule