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
    WALKING = 2'b01,
    DIGGING = 2'b10
} state, next_state;

// Define the walking directions
enum logic [0:0] {
    LEFT = 1'b0,
    RIGHT = 1'b1
} direction, next_direction;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        direction <= LEFT;
    end else begin
        state <= next_state;
        direction <= next_direction;
    end
end

// Condition modules
wire fall_condition = (!ground && (state == WALKING || state == DIGGING));
wire dig_condition = (dig && state == WALKING && ground);
wire walk_left_condition = (bump_right && direction == RIGHT);
wire walk_right_condition = (bump_left && direction == LEFT);

// Decision module
always_comb begin
    next_state = state;
    next_direction = direction;

    if (fall_condition) begin
        next_state = FALLING;
    end else if (dig_condition) begin
        next_state = DIGGING;
    end else if (walk_left_condition || walk_right_condition) begin
        if (walk_left_condition) begin
            next_direction = LEFT;
        end else begin
            next_direction = RIGHT;
        end
    end
end

// Output logic
assign walk_left = (state == WALKING && direction == LEFT);
assign walk_right = (state == WALKING && direction == RIGHT);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

// Clock gating and power-gating
wire clock_enable = (state != FALLING && (dig || bump_left || bump_right));
always_ff @(posedge clk) begin
    if (!clock_enable) begin
        // Power-gate the 'Falling' and 'Digging' modules
        // when the Lemming is walking and no dig or bump signals are present
    end
end

endmodule