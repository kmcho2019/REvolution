module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

typedef enum logic [0:0] {
    WALK_LEFT,
    WALK_RIGHT
} state_t;

state_t state;
state_t next_state;

// Combinational logic to determine the next state
always_comb begin
    next_state = state;

    if (ground) begin
        if (bump_left && bump_right) begin
            // Do nothing if bumped from both sides
        end else if (bump_left) begin
            next_state = WALK_RIGHT;
        end else if (bump_right) begin
            next_state = WALK_LEFT;
        end
    end
end

// Sequential logic to update the state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Output logic using assign statements
assign walk_left = (state == WALK_LEFT) && ground;
assign walk_right = (state == WALK_RIGHT) && ground;
assign aaah = ~ground;

endmodule