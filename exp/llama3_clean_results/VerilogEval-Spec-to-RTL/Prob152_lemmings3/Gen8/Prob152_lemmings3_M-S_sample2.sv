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
    WALKING = 2'b01
} state, next_state;

// Define the walking directions
enum logic {
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

// Combinational logic for next state
always_comb begin
    next_state = state;
    next_walk_direction = walk_direction;

    case (state)
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                // No separate state for digging, use walking state
                // and set digging output to 1
            end else if (bump_left) begin
                next_walk_direction = RIGHT;
            end else if (bump_right) begin
                next_walk_direction = LEFT;
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = WALKING;
            end
        end
    endcase
end

// Output logic
assign walk_left = (state == WALKING && walk_direction == LEFT) ? 1'b1 : 1'b0;
assign walk_right = (state == WALKING && walk_direction == RIGHT) ? 1'b1 : 1'b0;
assign aaah = (state == FALLING) ? 1'b1 : 1'b0;
assign digging = (state == WALKING && dig && ground) ? 1'b1 : 1'b0;

endmodule