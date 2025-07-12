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
    WALKING = 2'b01,
    FALLING = 2'b10,
    DIGGING = 2'b11
} state, next_state;

// Define the walking directions
enum logic [0:0] {
    LEFT = 1'b0,
    RIGHT = 1'b1
} direction, next_direction;

// Define the one-hot encoding for the states
reg [2:0] state_one_hot;
reg [2:0] next_state_one_hot;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        direction <= LEFT;
        state_one_hot <= 4'b001;
    end else begin
        state <= next_state;
        direction <= next_direction;
        state_one_hot <= next_state_one_hot;
    end
end

// Combinational logic for next state
always_comb begin
    next_state = state;
    next_direction = direction;
    next_state_one_hot = state_one_hot;

    case (state_one_hot)
        4'b001: begin // WALKING
            if (!ground) begin
                next_state_one_hot = 4'b010;
            end else if (dig) begin
                next_state_one_hot = 4'b100;
            end else if (bump_left && direction == LEFT) begin
                next_direction = RIGHT;
            end else if (bump_right && direction == RIGHT) begin
                next_direction = LEFT;
            end
        end
        4'b010: begin // FALLING
            if (ground) begin
                next_state_one_hot = 4'b001;
            end
        end
        4'b100: begin // DIGGING
            if (!ground) begin
                next_state_one_hot = 4'b010;
            end
        end
    endcase
end

// Output logic
assign walk_left = (state == WALKING && direction == LEFT);
assign walk_right = (state == WALKING && direction == RIGHT);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

endmodule