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

reg [1:0] state; // 2 bits to represent the state (00: walking left, 01: walking right, 10: falling left, 11: falling right)
reg [1:0] next_state;

// Combinational logic to determine the next state
always @(*) begin
    next_state = state;

    if (~ground) begin
        // falling, keep the direction
        next_state = {1'b1, state[0]};
    end else if (ground && (state[1] == 1'b1)) begin
        // stop falling, keep the direction
        next_state = {1'b0, state[0]};
    end else if ((bump_left && state[0] == 1'b0) || (bump_right && state[0] == 1'b1)) begin
        // change direction
        next_state = {state[1], ~state[0]};
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
    case(state)
        2'b00: // walking left
            begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
        2'b01: // walking right
            begin
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
            end
        2'b10, 2'b11: // falling
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
    endcase
end

endmodule