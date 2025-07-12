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

// Define the possible states
enum logic [1:0] {IDLE, WALK_LEFT, WALK_RIGHT, FALLING} state, next_state;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
    end else begin
        state <= next_state;
        walk_left <= (next_state == WALK_LEFT)? 1'b1 : 1'b0;
        walk_right <= (next_state == WALK_RIGHT)? 1'b1 : 1'b0;
        aaah <= (next_state == FALLING)? 1'b1 : 1'b0;
    end
end

// Combinational logic
always @(*) begin
    next_state = state;
    case (state)
        WALK_LEFT: begin
            if (ground == 0) begin
                next_state = FALLING;
            end else if (bump_left == 1'b1) begin
                next_state = WALK_RIGHT;
            end else if (bump_right == 1'b1) begin
                next_state = WALK_RIGHT;
            end
        end
        WALK_RIGHT: begin
            if (ground == 0) begin
                next_state = FALLING;
            end else if (bump_right == 1'b1) begin
                next_state = WALK_LEFT;
            end else if (bump_left == 1'b1) begin
                next_state = WALK_LEFT;
            end
        end
        FALLING: begin
            if (ground == 1'b1) begin
                if (state == WALK_LEFT) begin
                    next_state = WALK_LEFT;
                end else if (state == WALK_RIGHT) begin
                    next_state = WALK_RIGHT;
                end
            end
        end
        default: next_state = WALK_LEFT;
    endcase
end

endmodule