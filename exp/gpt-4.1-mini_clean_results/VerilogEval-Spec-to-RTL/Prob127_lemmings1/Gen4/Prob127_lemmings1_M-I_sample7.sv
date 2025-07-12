module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = walk_left, 1 = walk_right
    reg state;

    // Synchronizers for bump_left and bump_right
    reg [1:0] bump_left_sync;
    reg [1:0] bump_right_sync;

    // Rising edge detection signals
    wire bump_left_rising;
    wire bump_right_rising;

    // Synchronize bump_left to clk domain
    always @(posedge clk or posedge areset) begin
        if (areset)
            bump_left_sync <= 2'b00;
        else
            bump_left_sync <= {bump_left_sync[0], bump_left};
    end

    // Synchronize bump_right to clk domain
    always @(posedge clk or posedge areset) begin
        if (areset)
            bump_right_sync <= 2'b00;
        else
            bump_right_sync <= {bump_right_sync[0], bump_right};
    end

    // Detect rising edges
    assign bump_left_rising  = (bump_left_sync[1] == 1'b1) && (bump_left_sync[0] == 1'b0);
    assign bump_right_rising = (bump_right_sync[1] == 1'b1) && (bump_right_sync[0] == 1'b0);

    // FSM state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // walk_left
        else if (bump_left_rising || bump_right_rising)
            state <= ~state; // toggle direction on bump rising edge
    end

    assign walk_left  = ~state;
    assign walk_right = state;

endmodule