module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // One-hot state encoding for clarity and direct output mapping
    localparam WALK_LEFT  = 2'b01;
    localparam WALK_RIGHT = 2'b10;

    reg [1:0] state, next_state;

    // Combinational logic to determine next state
    always @(*) begin
        if (bump_left | bump_right) begin
            // If any bump, toggle direction by swapping bits
            if (state == WALK_LEFT)
                next_state = WALK_RIGHT;
            else
                next_state = WALK_LEFT;
        end else begin
            // No bump, maintain current state
            next_state = state;
        end
    end

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Outputs directly reflect one-hot state bits
    assign walk_left  = state[0];
    assign walk_right = state[1];

endmodule