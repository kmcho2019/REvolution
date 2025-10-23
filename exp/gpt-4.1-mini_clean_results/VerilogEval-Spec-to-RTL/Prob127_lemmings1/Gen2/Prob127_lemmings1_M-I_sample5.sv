module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = walk left, 1 = walk right
    reg state, next_state;

    // Synchronizers for bump inputs to avoid metastability and glitches
    reg [1:0] bump_left_sync;
    reg [1:0] bump_right_sync;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            bump_left_sync  <= 2'b00;
            bump_right_sync <= 2'b00;
        end else begin
            bump_left_sync  <= {bump_left_sync[0], bump_left};
            bump_right_sync <= {bump_right_sync[0], bump_right};
        end
    end

    wire bump_left_sync_stable  = bump_left_sync[1];
    wire bump_right_sync_stable = bump_right_sync[1];

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // WALK_LEFT
        else
            state <= next_state;
    end

    // Next state logic: toggle if any synchronized bump detected
    always @(*) begin
        if (bump_left_sync_stable || bump_right_sync_stable)
            next_state = ~state;
        else
            next_state = state;
    end

    // Moore outputs derived from state
    assign walk_left  = ~state;
    assign walk_right = state;

endmodule