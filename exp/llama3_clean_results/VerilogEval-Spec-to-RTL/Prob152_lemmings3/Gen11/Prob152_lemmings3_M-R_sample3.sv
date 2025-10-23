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

// Combinational logic for next state and walking direction
assign next_state = (state == WALKING && !ground) ? FALLING :
                    (state == WALKING && dig) ? DIGGING :
                    (state == FALLING && ground) ? WALKING :
                    (state == DIGGING && !ground) ? FALLING : state;

assign next_walk_direction = (bump_left && state == WALKING) ? RIGHT :
                             (bump_right && state == WALKING) ? LEFT : walk_direction;

// Output logic
assign walk_left = (state == WALKING && walk_direction == LEFT) ? 1'b1 : 1'b0;
assign walk_right = (state == WALKING && walk_direction == RIGHT) ? 1'b1 : 1'b0;
assign aaah = (state == FALLING) ? 1'b1 : 1'b0;
assign digging = (state == DIGGING) ? 1'b1 : 1'b0;

endmodule