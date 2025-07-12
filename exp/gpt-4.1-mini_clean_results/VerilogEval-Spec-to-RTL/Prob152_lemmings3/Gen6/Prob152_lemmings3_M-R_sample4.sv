module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// State encoding
typedef enum logic [1:0] {
    WALKING = 2'b00,
    FALLING = 2'b01,
    DIGGING = 2'b10
} state_t;

state_t state, next_state;
logic dir, next_dir;          // direction: 0=left, 1=right
logic prev_ground;

// prev_ground register: tracks last cycle ground value
always_ff @(posedge clk or posedge areset) begin
    if (areset)
        prev_ground <= 1'b1;  // assume starting on ground
    else
        prev_ground <= ground;
end

// FSM state and direction update
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        dir   <= 1'b0; // walk left on reset
    end else begin
        state <= next_state;
        dir   <= next_dir;
    end
end

// stable_ground for bump and dig conditions
logic stable_ground = (ground == 1'b1) && (prev_ground == 1'b1);

// Determine next direction during walking and stable ground with bumps
always_comb begin
    next_dir = dir;
    if (state == WALKING && stable_ground && (bump_left || bump_right)) begin
        if (bump_left && bump_right)
            next_dir = ~dir;           // toggle direction
        else if (bump_left)
            next_dir = 1'b1;           // walk right
        else if (bump_right)
            next_dir = 1'b0;           // walk left
    end
end

// Next state logic with priority fall > dig > bump (bump handled separately)
always_comb begin
    next_state = state;
    case (state)
        WALKING: begin
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else if (dig && stable_ground) begin
                next_state = DIGGING;
            end else begin
                next_state = WALKING; // no state change on bump
            end
        end
        FALLING: begin
            if (ground == 1'b1) begin
                next_state = WALKING;
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        default: begin
            next_state = WALKING;
        end
    endcase
end

// Outputs: Moore FSM outputs depend on current state and direction
assign walk_left  = (state == WALKING) && (dir == 1'b0);
assign walk_right = (state == WALKING) && (dir == 1'b1);
assign aaah       = (state == FALLING);
assign digging    = (state == DIGGING);

endmodule