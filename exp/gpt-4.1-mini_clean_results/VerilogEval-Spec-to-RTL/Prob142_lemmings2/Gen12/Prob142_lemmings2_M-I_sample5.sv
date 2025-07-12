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

    reg [1:0] state; // [1]: falling, [0]: direction (0=left, 1=right)
    reg [1:0] next_state;

    wire any_bump = bump_left | bump_right;

    always @* begin
        if (state[1]) begin
            // Falling state: remain falling until ground returns, direction unchanged
            next_state = ground ? {1'b0, state[0]} : state;
        end else begin
            // Walking state
            if (!ground) begin
                // Start falling, direction preserved
                next_state = {1'b1, state[0]};
            end else if (any_bump) begin
                // Bump in any direction causes direction toggle
                next_state = {1'b0, ~state[0]};
            end else begin
                // No bump, no ground change: stay walking same direction
                next_state = state;
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // walking left
        else
            state <= next_state;
    end

    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] &  state[0];

endmodule