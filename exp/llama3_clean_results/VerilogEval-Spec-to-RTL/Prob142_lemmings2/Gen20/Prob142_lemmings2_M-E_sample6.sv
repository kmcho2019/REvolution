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

reg [1:0] state; // 2-bit state variable (0: left, not falling; 1: right, not falling; 2: left, falling; 3: right, falling)
reg [1:0] next_state;

// Combinational logic to determine the next state
always @(*) begin
    next_state = state;
    if (!ground) begin
        next_state = {state[0], 1'b1}; // set falling state
    end else if (ground && state[1]) begin
        next_state = {state[0], 1'b0}; // clear falling state
    end else if (bump_left && !state[0]) begin
        next_state = {1'b1, state[1]}; // toggle walking direction
    end else if (bump_right && state[0]) begin
        next_state = {1'b0, state[1]}; // toggle walking direction
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to left, not falling
    end else begin
        state <= next_state;
    end
end

// Output logic
assign walk_left = (state == 2'b00 || state == 2'b10) ? 1'b1 : 1'b0;
assign walk_right = (state == 2'b01 || state == 2'b11) ? 1'b1 : 1'b0;
assign aaah = state[1] ? 1'b1 : 1'b0;

endmodule