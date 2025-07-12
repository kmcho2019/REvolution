module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states
enum logic [1:0] {
    IDLE_LEFT,
    IDLE_RIGHT,
    FALLING,
    DIGGING
} state, next_state;

// Current walking direction
logic walking_left;

// Output logic
assign walk_left = state == IDLE_LEFT;
assign walk_right = state == IDLE_RIGHT;
assign aaah = state == FALLING;
assign digging = state == DIGGING;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        walking_left <= 1;
    end else begin
        case (state)
            IDLE_LEFT: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    state <= IDLE_RIGHT;
                    walking_left <= 0;
                end else if (bump_right) begin
                    // no change
                end else begin
                    // no change
                end
            end
            IDLE_RIGHT: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_right) begin
                    state <= IDLE_LEFT;
                    walking_left <= 1;
                end else if (bump_left) begin
                    // no change
                end else begin
                    // no change
                end
            end
            FALLING: begin
                if (ground) begin
                    if (walking_left) begin
                        state <= IDLE_LEFT;
                    end else begin
                        state <= IDLE_RIGHT;
                    end
                end else begin
                    // no change
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                end else begin
                    // no change
                end
            end
        endcase
    end
end

endmodule