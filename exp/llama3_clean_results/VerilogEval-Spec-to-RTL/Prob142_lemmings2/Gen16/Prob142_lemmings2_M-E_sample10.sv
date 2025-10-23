module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

// Enumerations for sub-states
enum logic [1:0] {
    WALK_LEFT,
    WALK_RIGHT
} walking_state, next_walking_state;

// Higher-level state machine
enum logic {
    IDLE,
    FALLING
} top_state, next_top_state;

// Sequential logic for walking state machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        walking_state <= WALK_LEFT;
    end else if (top_state == IDLE) begin
        walking_state <= next_walking_state;
    end
end

// Combinational logic for walking state machine
always @(*) begin
    next_walking_state = walking_state;
    
    case(walking_state)
        WALK_LEFT: begin
            if (bump_left) begin
                next_walking_state = WALK_RIGHT;
            end else if (bump_right) begin
                // No change, keep walking left
            end
        end
        WALK_RIGHT: begin
            if (bump_right) begin
                next_walking_state = WALK_LEFT;
            end else if (bump_left) begin
                // No change, keep walking right
            end
        end
    endcase
end

// Sequential logic for top-level state machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        top_state <= IDLE;
    end else begin
        top_state <= next_top_state;
    end
end

// Combinational logic for top-level state machine
always @(*) begin
    next_top_state = top_state;
    
    case(top_state)
        IDLE: begin
            if (~ground) begin
                next_top_state = FALLING;
            end
        end
        FALLING: begin
            if (ground) begin
                next_top_state = IDLE;
            end
        end
    endcase
end

// Output logic
always @(*) begin
    walk_left = (top_state == IDLE && walking_state == WALK_LEFT) ? 1'b1 : 1'b0;
    walk_right = (top_state == IDLE && walking_state == WALK_RIGHT) ? 1'b1 : 1'b0;
    aaah = (top_state == FALLING) ? 1'b1 : 1'b0;
end

endmodule