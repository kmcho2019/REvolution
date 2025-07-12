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
enum {IDLE_LEFT, IDLE_RIGHT, FALLING, DIGGING} state, next_state;

// Initialize state
initial state = IDLE_LEFT;

// Assign outputs based on state
always @(*) begin
    walk_left = (state == IDLE_LEFT);
    walk_right = (state == IDLE_RIGHT);
    aaah = (state == FALLING);
    digging = (state == DIGGING);
end

// State transition logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        case (state)
            IDLE_LEFT: begin
                if (!ground) begin
                    next_state <= FALLING;
                end else if (dig) begin
                    next_state <= DIGGING;
                end else if (bump_right) begin
                    next_state <= IDLE_RIGHT;
                end else if (bump_left) begin
                    // No change
                end else begin
                    next_state <= IDLE_LEFT;
                end
            end
            IDLE_RIGHT: begin
                if (!ground) begin
                    next_state <= FALLING;
                end else if (dig) begin
                    next_state <= DIGGING;
                end else if (bump_left) begin
                    next_state <= IDLE_LEFT;
                end else if (bump_right) begin
                    // No change
                end else begin
                    next_state <= IDLE_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (next_state == DIGGING) begin
                        next_state <= IDLE_LEFT;
                    end else if (next_state == IDLE_RIGHT) begin
                        next_state <= IDLE_RIGHT;
                    end else begin
                        next_state <= IDLE_LEFT;
                    end
                end else begin
                    next_state <= FALLING;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state <= FALLING;
                end else begin
                    next_state <= DIGGING;
                end
            end
            default: begin
                next_state <= IDLE_LEFT;
            end
        endcase
        state <= next_state;
    end
end

endmodule