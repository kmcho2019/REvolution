module TopModule (
    input         clk,
    input         areset,
    input         bump_left,
    input         bump_right,
    input         ground,
    input         dig,
    output        walk_left,
    output        walk_right,
    output        aaah,
    output        digging
);

// Enum for the states
enum logic [1:0] {WALKING, FALLING, DIGGING} state, next_state;

// Signal to keep track of the walking direction
logic walking_left, next_walking_left;

// Walking direction module
always_comb begin
    next_walking_left = walking_left;
    if (bump_left && !bump_right) begin
        next_walking_left = 1'b0;
    end else if (bump_right && !bump_left) begin
        next_walking_left = 1'b1;
    end
end

// Main state machine
always_comb begin
    next_state = state;
    case (state)
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = WALKING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (!dig) begin
                next_state = WALKING;
            end
        end
        default: next_state = WALKING;
    endcase
end

// Sequential logic for the state and walking_left signals
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walking_left <= 1'b1;
    end else begin
        state <= next_state;
        walking_left <= next_walking_left;
    end
end

// Output logic
assign walk_left = (state == WALKING && walking_left);
assign walk_right = (state == WALKING && !walking_left);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

endmodule