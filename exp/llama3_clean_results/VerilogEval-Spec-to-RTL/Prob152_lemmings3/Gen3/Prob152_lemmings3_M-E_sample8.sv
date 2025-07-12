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
    IDLE = 2'b00,
    WALKING = 2'b01,
    FALLING = 2'b10,
    DIGGING = 2'b11
} state, next_state;

// Define the walking directions
enum logic [1:0] {
    LEFT = 2'b00,
    RIGHT = 2'b01
} direction, next_direction;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        direction <= LEFT;
    end else begin
        state <= next_state;
        direction <= next_direction;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    next_direction = direction;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        IDLE: begin
            if (ground) begin
                next_state = WALKING;
            end
        end
        WALKING: begin
            if (direction == LEFT) begin
                walk_left = 1'b1;
            end else begin
                walk_right = 1'b1;
            end
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                if (direction == LEFT) begin
                    next_direction = RIGHT;
                end else begin
                    next_direction = LEFT;
                end
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
    endcase
end

endmodule