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

// Top-Level FSM States
enum logic [1:0] {
    FALLING = 2'b00,
    WALKING = 2'b01,
    DIGGING = 2'b10
} tl_state, next_tl_state;

// Walking Direction Sub-FSM
enum logic [0:0] {
    LEFT = 1'b0,
    RIGHT = 1'b1
} walk_dir, next_walk_dir;

// Digging Sub-FSM State
enum logic [0:0] {
    NOT_DIGGING = 1'b0,
    DIGGING_ACTIVE = 1'b1
} dig_state, next_dig_state;

// Sequential Logic for Top-Level FSM
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        tl_state <= WALKING;
        walk_dir <= LEFT;
        dig_state <= NOT_DIGGING;
    end else begin
        tl_state <= next_tl_state;
        walk_dir <= next_walk_dir;
        dig_state <= next_dig_state;
    end
end

// Combinational Logic for Next States
always_comb begin
    next_tl_state = tl_state;
    next_walk_dir = walk_dir;
    next_dig_state = dig_state;

    case (tl_state)
        WALKING: begin
            if (!ground) begin
                next_tl_state = FALLING;
            end else if (dig) begin
                next_tl_state = DIGGING;
                next_dig_state = DIGGING_ACTIVE;
            end else if (bump_left) begin
                next_walk_dir = RIGHT;
            end else if (bump_right) begin
                next_walk_dir = LEFT;
            end
        end
        FALLING: begin
            if (ground) begin
                next_tl_state = WALKING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_tl_state = FALLING;
                next_dig_state = NOT_DIGGING;
            end
        end
    endcase
end

// Output Logic
assign walk_left = (tl_state == WALKING && walk_dir == LEFT) ? 1'b1 : 1'b0;
assign walk_right = (tl_state == WALKING && walk_dir == RIGHT) ? 1'b1 : 1'b0;
assign aaah = (tl_state == FALLING) ? 1'b1 : 1'b0;
assign digging = (dig_state == DIGGING_ACTIVE) ? 1'b1 : 1'b0;

endmodule