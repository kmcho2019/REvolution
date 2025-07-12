module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // State encoding
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // Async reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end else begin
            state <= next_state;
            // Moore outputs updated synchronously from state
            walk_left <= (next_state == WALK_LEFT);
            walk_right <= (next_state == WALK_RIGHT);
        end
    end

    // Next state logic: invert state if bumped on any side, else hold state
    always @(*) begin
        if (bump_left || bump_right)
            next_state = ~state;
        else
            next_state = state;
    end

endmodule