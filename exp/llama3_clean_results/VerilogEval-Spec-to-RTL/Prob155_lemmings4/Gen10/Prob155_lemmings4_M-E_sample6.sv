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

// Define the top-level states
enum logic [1:0] {
    WALKING = 2'b00,
    FALLING = 2'b01,
    DIGGING = 2'b10,
    SPLATTERED = 2'b11
} state, next_state;

// Define the sub-states for WALKING
enum logic {
    WALK_LEFT = 1'b0,
    WALK_RIGHT = 1'b1
} walk_substate, next_walk_substate;

// Define the sub-states for FALLING
enum logic {
    FALLING_INIT = 1'b0,
    FALLING_COUNT = 1'b1
} fall_substate, next_fall_substate;

// Define the fall counter
reg [4:0] fall_counter;

// Update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_substate <= WALK_LEFT;
        fall_substate <= FALLING_INIT;
        fall_counter <= 5'b0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        state <= next_state;
        walk_substate <= next_walk_substate;
        fall_substate <= next_fall_substate;
        if (state == WALKING) begin
            if (walk_substate == WALK_LEFT) begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end else begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end
            aaah <= 1'b0;
            digging <= 1'b0;
        end else if (state == FALLING) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
            digging <= 1'b0;
            if (fall_substate == FALLING_COUNT) begin
                fall_counter <= fall_counter + 1'b1;
            end
        end else if (state == DIGGING) begin
            if (walk_substate == WALK_LEFT) begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end else begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end
            aaah <= 1'b0;
            digging <= 1'b1;
        end else if (state == SPLATTERED) begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end
    end
end

// Calculate the next state
always @(*) begin
    case (state)
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
                next_walk_substate = walk_substate;
                next_fall_substate = FALLING_INIT;
            end else if (dig) begin
                next_state = DIGGING;
                next_walk_substate = walk_substate;
            end else if (bump_left && !bump_right) begin
                next_state = WALKING;
                next_walk_substate = WALK_RIGHT;
            end else if (bump_right && !bump_left) begin
                next_state = WALKING;
                next_walk_substate = WALK_LEFT;
            end else if (bump_left && bump_right) begin
                next_state = WALKING;
                next_walk_substate = ~walk_substate;
            end else begin
                next_state = WALKING;
                next_walk_substate = walk_substate;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 5'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = WALKING;
                    next_walk_substate = walk_substate;
                end
                fall_counter <= 5'b0;
            end else begin
                next_state = FALLING;
                next_walk_substate = walk_substate;
                next_fall_substate = FALLING_COUNT;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
                next_walk_substate = walk_substate;
                next_fall_substate = FALLING_INIT;
            end else if (!dig) begin
                next_state = WALKING;
                next_walk_substate = walk_substate;
            end else begin
                next_state = DIGGING;
                next_walk_substate = walk_substate;
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
            next_walk_substate = walk_substate;
        end
    endcase
end

endmodule