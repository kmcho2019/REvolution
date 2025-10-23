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
enum logic [1:0] {IDLE_LEFT, IDLE_RIGHT, FALLING} state, next_state;

// Signal to keep track of the direction the Lemming was walking before it fell or started digging
logic walking_left_before_fall;

// Initialize the state and walking_left_before_fall signals
initial begin
    state = IDLE_LEFT;
    walking_left_before_fall = 1'b1;
end

// Combinational logic for the next state
always_comb begin
    next_state = state;
    case (state)
        IDLE_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_right) begin
                next_state = IDLE_RIGHT;
            end else if (dig) begin
                next_state = IDLE_LEFT;
                // Start digging
            end
        end
        IDLE_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = IDLE_LEFT;
            end else if (dig) begin
                next_state = IDLE_RIGHT;
                // Start digging
            end
        end
        FALLING: begin
            if (ground) begin
                if (walking_left_before_fall) begin
                    next_state = IDLE_LEFT;
                end else begin
                    next_state = IDLE_RIGHT;
                end
            end
        end
        default: next_state = IDLE_LEFT;
    endcase
end

// Sequential logic for the state and walking_left_before_fall signals
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        walking_left_before_fall <= 1'b1;
    end else begin
        state <= next_state;
        if (state == IDLE_LEFT) begin
            walking_left_before_fall <= 1'b1;
        end else if (state == IDLE_RIGHT) begin
            walking_left_before_fall <= 1'b0;
        end
    end
end

// Output logic
assign walk_left = (state == IDLE_LEFT);
assign walk_right = (state == IDLE_RIGHT);
assign aaah = (state == FALLING);
assign digging = (dig && ground);

endmodule