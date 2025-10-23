module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // Define states for clarity
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // Combinational logic to determine next state
    always @(*) begin
        if (bump_left | bump_right) begin
            // If bumped on either side, reverse direction
            next_state = ~state;
        end else begin
            // No bump, maintain current direction
            next_state = state;
        end
    end

    // Sequential logic to update state with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Output assignments for Moore machine
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule