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

// Define states
enum logic [1:0] {LEFT, RIGHT, FALLING} state, next_state;

// Combinational logic to determine the next state
always_comb begin
    next_state = state;

    case (state)
        LEFT: begin
            if (bump_right) next_state = RIGHT;
            else if (!ground) next_state = FALLING;
        end
        RIGHT: begin
            if (bump_left) next_state = LEFT;
            else if (!ground) next_state = FALLING;
        end
        FALLING: begin
            if (ground) next_state = (bump_left || bump_right) ? (state == LEFT ? RIGHT : LEFT) : state;
        end
    endcase
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        state <= next_state;
    end
end

// Output logic
always_comb begin
    walk_left = (state == LEFT && state != FALLING) ? 1'b1 : 1'b0;
    walk_right = (state == RIGHT && state != FALLING) ? 1'b1 : 1'b0;
    aaah = (state == FALLING) ? 1'b1 : 1'b0;
end

endmodule