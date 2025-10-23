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

// Instantiate state modules
walking_module walking_inst (
    .clk(clk),
    .areset(areset),
    .bump_left(bump_left),
    .bump_right(bump_right),
    .ground(ground),
    .dig(dig),
    .walk_direction(walk_direction),
    .next_walk_direction(next_walk_direction)
);

falling_module falling_inst (
    .clk(clk),
    .areset(areset),
    .ground(ground),
    .state(state),
    .next_state(next_state)
);

digging_module digging_inst (
    .clk(clk),
    .areset(areset),
    .ground(ground),
    .dig(dig),
    .state(state),
    .next_state(next_state)
);

// Top-level FSM
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
                next_state = DIGGING;
            end else if (bump_left && walk_direction == LEFT) begin
                next_walk_direction = RIGHT;
            end else if (bump_right && walk_direction == RIGHT) begin
                next_walk_direction = LEFT;
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = WALKING;
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
assign walk_left = (state == WALKING && walk_direction == LEFT) ? 1'b1 : 1'b0;
assign walk_right = (state == WALKING && walk_direction == RIGHT) ? 1'b1 : 1'b0;
assign aaah = (state == FALLING) ? 1'b1 : 1'b0;
assign digging = (state == DIGGING) ? 1'b1 : 1'b0;

endmodule

// Module definitions for each state
module walking_module (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_direction,
    output reg next_walk_direction
);

// Implement walking logic here

endmodule

module falling_module (
    input  clk,
    input  areset,
    input  ground,
    input  state,
    output reg next_state
);

// Implement falling logic here

endmodule

module digging_module (
    input  clk,
    input  areset,
    input  ground,
    input  dig,
    input  state,
    output reg next_state
);

// Implement digging logic here

endmodule