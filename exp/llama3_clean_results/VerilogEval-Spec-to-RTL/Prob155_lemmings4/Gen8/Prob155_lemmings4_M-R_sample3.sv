module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define states
typedef enum logic [2:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state_t;

state_t state;
state_t next_state;

// Define direction
typedef enum logic [1:0] {
    LEFT,
    RIGHT
} dir_t;

dir_t dir;
dir_t next_dir;

// Define fall counter
reg [4:0] fall_counter;
reg [4:0] next_fall_counter;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        dir <= LEFT;
        fall_counter <= 5'b0;
    end else begin
        state <= next_state;
        dir <= next_dir;
        fall_counter <= next_fall_counter;
    end
end

// Next state logic
always_comb begin
    next_state = state;
    next_dir = dir;
    next_fall_counter = fall_counter;

    case (state)
        WALK_LEFT: begin
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 5'b1;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                next_state = WALK_RIGHT;
                next_dir = RIGHT;
            end
        end
        WALK_RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 5'b1;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                next_state = WALK_LEFT;
                next_dir = LEFT;
            end
        end
        FALLING: begin
            next_fall_counter = fall_counter + 1'b1;
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = (dir == LEFT) ? WALK_LEFT : WALK_RIGHT;
                    next_fall_counter = 5'b0;
                end
            end
        end
        DIGGING: begin
            if (~ground) begin
                next_state = FALLING;
                next_fall_counter = 5'b1;
            end
        end
        SPLATTERED: begin
            // do nothing
        end
    endcase
end

// Output logic
assign walk_left = (state == WALK_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (state == WALK_RIGHT) ? 1'b1 : 1'b0;
assign aaah = (state == FALLING) ? 1'b1 : 1'b0;
assign digging = (state == DIGGING) ? 1'b1 : 1'b0;

endmodule