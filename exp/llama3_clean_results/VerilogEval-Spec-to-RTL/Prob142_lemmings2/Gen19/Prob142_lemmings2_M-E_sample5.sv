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

reg [1:0] state; // 2 bits to represent the state (0: walking left, 1: walking right, 2: falling)
reg [1:0] next_state;

// Combinational logic to determine the next state
always @(*) begin
    next_state = state;

    if (~ground && state[1] == 0) begin
        next_state = 2'b10; // falling
    end else if (ground && state[1] == 1) begin
        next_state = {state[0], 1'b0}; // walking
    end else if ((bump_left && state[0] == 1'b0) || (bump_right && state[0] == 1'b1)) begin
        next_state = {~state[0], state[1]}; // change direction
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else if (next_state != state) begin
        state <= next_state;
    end
end

// Output logic
always @(*) begin
    walk_left = ~state[0] && ~state[1];
    walk_right = state[0] && ~state[1];
    aaah = state[1];
end

endmodule