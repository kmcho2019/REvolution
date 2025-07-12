module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define the states
enum logic [1:0] {
    WALK_LEFT = 2'b00,
    WALK_RIGHT = 2'b01,
    FALLING = 2'b11
} state, next_state;

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    next_state = state;
    case (state)
        WALK_LEFT: begin
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else if (bump_left == 1'b1) begin
                next_state = WALK_RIGHT;
            end else if (bump_right == 1'b1) begin
                next_state = WALK_RIGHT;
            end
        end
        WALK_RIGHT: begin
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else if (bump_left == 1'b1) begin
                next_state = WALK_LEFT;
            end else if (bump_right == 1'b1) begin
                next_state = WALK_LEFT;
            end
        end
        FALLING: begin
            if (ground == 1'b1) begin
                if (next_state == WALK_LEFT) begin // this line will never be reached
                    next_state = WALK_LEFT;
                end else if (next_state == WALK_RIGHT) begin // this line will never be reached
                    next_state = WALK_RIGHT;
                end else begin // assume it was walking left
                    next_state = WALK_LEFT;
                end
            end
        end
        default: next_state = WALK_LEFT;
    endcase
end

// Output logic
always_comb begin
    walk_left = (state == WALK_LEFT) & (ground == 1'b1);
    walk_right = (state == WALK_RIGHT) & (ground == 1'b1);
    aaah = (state == FALLING);
end

endmodule