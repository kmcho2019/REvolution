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
logic walking_left;

// Initialize the state and walking_left signals
initial begin
    state = WALKING;
    walking_left = 1'b1;
end

// Combinational logic for the next state
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

// Combinational logic for the walking direction
always_comb begin
    if (state == WALKING) begin
        if (bump_left && !bump_right) begin
            walking_left = 1'b0;
        end else if (bump_right && !bump_left) begin
            walking_left = 1'b1;
        end
    end
end

// Sequential logic for the state and walking_left signals
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walking_left <= 1'b1;
    end else begin
        state <= next_state;
    end
end

// Output logic
assign walk_left = (state == WALKING && walking_left);
assign walk_right = (state == WALKING && !walking_left);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

endmodule