module TopModule (
    input         clk,
    input         areset,
    input         bump_left,
    input         bump_right,
    input         ground,
    output        walk_left,
    output        walk_right,
    output        aaah
);

// Define the states
enum logic [1:0] {IDLE_LEFT, IDLE_RIGHT, FALLING} state, next_state;

// Define the outputs
assign walk_left = (state == IDLE_LEFT);
assign walk_right = (state == IDLE_RIGHT);
assign aaah = (state == FALLING);

// Define the state machine logic
always_comb begin
    case (state)
        IDLE_LEFT: begin
            if (ground == 0) begin
                next_state = FALLING;
            end else if (bump_left == 1 || bump_right == 1) begin
                next_state = IDLE_RIGHT;
            end else begin
                next_state = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if (ground == 0) begin
                next_state = FALLING;
            end else if (bump_left == 1 || bump_right == 1) begin
                next_state = IDLE_LEFT;
            end else begin
                next_state = IDLE_RIGHT;
            end
        end
        FALLING: begin
            if (ground == 1) begin
                if (next_state == IDLE_LEFT) begin
                    next_state = IDLE_LEFT;
                end else if (next_state == IDLE_RIGHT) begin
                    next_state = IDLE_RIGHT;
                end else if (bump_left == 1 || bump_right == 1) begin
                    // Do nothing, next_state is still FALLING
                end else begin
                    // If next_state is not updated, it will remain FALLING
                end
            end else begin
                next_state = FALLING;
            end
        end
        default: next_state = IDLE_LEFT;
    endcase
end

// Update the state on the positive edge of the clock
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
    end else begin
        state <= next_state;
    end
end

endmodule