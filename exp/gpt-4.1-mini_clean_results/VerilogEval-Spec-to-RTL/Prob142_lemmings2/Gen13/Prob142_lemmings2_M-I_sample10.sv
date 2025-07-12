module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    reg [1:0] state;      // [1] = falling, [0] = direction (0=left, 1=right)
    reg [1:0] next_state;

    wire bump_any = bump_left | bump_right;

    // Next state logic
    always @* begin
        if (state[1]) begin
            // Falling: remain falling until ground returns
            next_state = ground ? {1'b0, state[0]} : state;
        end else begin
            // Walking on ground
            if (!ground)
                next_state = {1'b1, state[0]};
            else if (bump_any)
                next_state = {1'b0, ~state[0]};
            else
                next_state = state;
        end
    end

    wire state_changed = (next_state != state);

    // Clock gated state update for power saving
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // walk left after reset
        else if (state_changed)
            state <= next_state;
    end

    // Outputs
    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] &  state[0];

endmodule