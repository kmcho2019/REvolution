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
enum logic [1:0] {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING} state, next_state;

// Signal to keep track of the direction the Lemming was walking before it fell or started digging
logic walking_left_before_fall;

// Initialize the state and walking_left_before_fall signals
initial begin
    state = WALK_LEFT;
    walking_left_before_fall = 1'b1;
end

// Combinational logic for the next state
always_comb begin
    next_state = state;
    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (dig) begin
                next_state = DIGGING;
            end
        end
        FALLING: begin
            if (ground) begin
                if (walking_left_before_fall) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (!dig) begin
                if (walking_left_before_fall) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
        end
        default: next_state = WALK_LEFT;
    endcase
end

// Sequential logic for the state and walking_left_before_fall signals
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        walking_left_before_fall <= 1'b1;
    end else begin
        state <= next_state;
        case (next_state)
            WALK_LEFT: walking_left_before_fall <= 1'b1;
            WALK_RIGHT: walking_left_before_fall <= 1'b0;
            FALLING: begin
                if (state == WALK_LEFT) begin
                    walking_left_before_fall <= 1'b1;
                end else if (state == WALK_RIGHT) begin
                    walking_left_before_fall <= 1'b0;
                end
            end
            DIGGING: begin
                if (state == WALK_LEFT) begin
                    walking_left_before_fall <= 1'b1;
                end else if (state == WALK_RIGHT) begin
                    walking_left_before_fall <= 1'b0;
                end
            end
            default: walking_left_before_fall <= 1'b1;
        endcase
    end
end

// Output logic
assign walk_left = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

endmodule