module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

    // Define state encoding using localparam for clarity
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic: explicit conditional statements for clarity
    always @(*) begin
        if (bump_left) begin
            // Bumped on left side => walk right
            next_state = WALK_RIGHT;
        end else if (bump_right) begin
            // Bumped on right side only => walk left
            next_state = WALK_LEFT;
        end else begin
            // No bumps => hold state
            next_state = state;
        end
    end

    // Output logic (Moore machine): one-hot output
    always @(*) begin
        walk_left  = (state == WALK_LEFT);
        walk_right = (state == WALK_RIGHT);
    end

endmodule