module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);
    // State encoding
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    // Synchronizers for bump_left and bump_right
    reg [1:0] bump_left_sync;
    reg [1:0] bump_right_sync;

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

    // Detect rising edges of synchronized bumps
    wire bump_left_rising  = (bump_left_sync[1] == 0) && (bump_left_sync[0] == 1);
    wire bump_right_rising = (bump_right_sync[1] == 0) && (bump_right_sync[0] == 1);

    // FSM state register
    reg state;

    // FSM sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else if (bump_left_rising || bump_right_rising) begin
            state <= ~state; // switch direction on bump edge
        end
    end

    // Moore outputs
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule