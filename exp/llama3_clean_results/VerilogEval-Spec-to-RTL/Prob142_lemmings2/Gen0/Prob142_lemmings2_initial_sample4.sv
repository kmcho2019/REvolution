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

// Enumerate the states
enum logic [1:0] {
    IDLE_LEFT,
    IDLE_RIGHT,
    FALLING_LEFT,
    FALLING_RIGHT
} state, next_state;

always @(*) begin
    // Default next state is the current state
    next_state = state;

    // Logic to determine the next state
    case(state)
        IDLE_LEFT: begin
            if (~ground) begin
                next_state = FALLING_LEFT;
            end else if (bump_left) begin
                next_state = IDLE_RIGHT;
            end else if (bump_right) begin
                next_state = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if (~ground) begin
                next_state = FALLING_RIGHT;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
            end else if (bump_right) begin
                next_state = IDLE_RIGHT;
            end
        end
        FALLING_LEFT: begin
            if (ground) begin
                next_state = IDLE_LEFT;
            end
        end
        FALLING_RIGHT: begin
            if (ground) begin
                next_state = IDLE_RIGHT;
            end
        end
    endcase
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

// Output logic
always @(*) begin
    case(state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        IDLE_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        FALLING_LEFT: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        FALLING_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
    endcase
end

endmodule