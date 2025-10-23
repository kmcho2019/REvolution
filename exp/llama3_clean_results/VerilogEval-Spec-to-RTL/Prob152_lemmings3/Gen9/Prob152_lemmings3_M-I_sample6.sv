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

// Combinational logic for next state
always_comb begin
    next_state = state;
    next_direction = direction;

    if (state == WALKING) begin
        if (!ground) begin
            next_state = FALLING;
        end else if (dig) begin
            next_state = DIGGING;
        end else if (bump_left && direction == LEFT) begin
            next_direction = RIGHT;
        end else if (bump_right && direction == RIGHT) begin
            next_direction = LEFT;
        end
    end else if (state == FALLING) begin
        if (ground) begin
            next_state = WALKING;
        end
    end else if (state == DIGGING) begin
        if (!ground) begin
            next_state = FALLING;
        end
    end
end

// Output logic
assign walk_left = (state == WALKING && direction == LEFT);
assign walk_right = (state == WALKING && direction == RIGHT);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

endmodule