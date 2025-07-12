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

    // State encoding (2 bits):
    // bit1: falling (1) or walking (0)
    // bit0: direction (0=left, 1=right)
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state, next_state;

    wire bump_both = bump_left & bump_right;
    wire bump_any  = bump_left | bump_right;

    always @(*) begin
        next_state = state;  // default hold

        if (state[1] == 1'b0) begin
            // Walking state
            if (ground == 1'b0) begin
                // Ground gone, start falling, keep direction
                next_state = {1'b1, state[0]};
            end else if (bump_both) begin
                // Both bumps flip direction
                next_state = {1'b0, ~state[0]};
            end else if (bump_left) begin
                // Bump left: walk right
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                // Bump right: walk left
                next_state = WALK_LEFT;
            end else begin
                // No bump, remain walking same direction
                next_state = state;
            end
        end else begin
            // Falling state
            if (ground == 1'b1) begin
                // Ground back, resume walking same direction
                next_state = {1'b0, state[0]};
            end else begin
                // Still falling, direction unchanged
                next_state = state;
            end
        end
    end

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT; // reset to walking left
        end else begin
            state <= next_state;
        end
    end

    // Moore outputs from state bits
    assign aaah       = state[1];           // falling bit
    assign walk_left  = (~state[1]) & (~state[0]);
    assign walk_right = (~state[1]) & ( state[0]);

endmodule