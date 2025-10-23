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

reg [1:0] state; // 2 bits to represent the state (00: walking left, 01: walking right, 10: falling)
reg [1:0] next_state;

// Combinational logic to determine the next state
always @(*) begin
    next_state = state;

    if (~ground) begin
        next_state = 2'b10; // falling
    end else if (ground && state == 2'b10) begin
        next_state = state[0]? 2'b01 : 2'b00; // resume walking
    end else if (bump_left || bump_right) begin
        next_state = {1'b0, ~state[0]}; // change direction
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        state <= next_state;
    end
end

// Output logic
always @(*) begin
    walk_left = (state == 2'b00)? 1'b1 : 1'b0;
    walk_right = (state == 2'b01)? 1'b1 : 1'b0;
    aaah = (state == 2'b10)? 1'b1 : 1'b0;
end

endmodule