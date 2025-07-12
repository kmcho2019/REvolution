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

// Top-level state machine
enum logic [1:0] {
    IDLE,
    WALKING,
    FALLING,
    DIGGING
} state;

// Sub-state machine for walking
enum logic {
    WALK_LEFT,
    WALK_RIGHT
} walk_state;

// Sub-state machine for digging
enum logic {
    DIGGING_START,
    DIGGING_PROGRESS
} dig_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        walk_state <= WALK_LEFT;
        dig_state <= DIGGING_START;
    end else begin
        case (state)
            IDLE: begin
                if (ground) begin
                    state <= WALKING;
                end
            end
            WALKING: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    walk_state <= WALK_RIGHT;
                end else if (bump_right) begin
                    walk_state <= WALK_LEFT;
                end
            end
            FALLING: begin
                if (ground) begin
                    state <= WALKING;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                end else begin
                    case (dig_state)
                        DIGGING_START: begin
                            dig_state <= DIGGING_PROGRESS;
                        end
                        DIGGING_PROGRESS: begin
                            // Digging logic here
                        end
                    endcase
                end
            end
        endcase
    end
end

always_comb begin
    walk_left = (state == WALKING && walk_state == WALK_LEFT) ? 1'b1 : 1'b0;
    walk_right = (state == WALKING && walk_state == WALK_RIGHT) ? 1'b1 : 1'b0;
    aaah = (state == FALLING) ? 1'b1 : 1'b0;
    digging = (state == DIGGING) ? 1'b1 : 1'b0;
end

endmodule