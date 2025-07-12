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

    always @(*) begin
        // Default: hold current state
        next_state = state;

        if (state[1] == 1'b0) begin
            // Walking states
            if (ground == 1'b0) begin
                // Start falling, preserve direction bit0
                next_state = {1'b1, state[0]};
            end else begin
                // On ground and walking: bumps can change direction
                if (bump_left && bump_right) begin
                    // Both bumps flip direction
                    next_state = {1'b0, ~state[0]};
                end else if (bump_left) begin
                    // Bump left -> walk right
                    next_state = {1'b0, 1'b1};
                end else if (bump_right) begin
                    // Bump right -> walk left
                    next_state = {1'b0, 1'b0};
                end else begin
                    // No bumps: remain walking same direction
                    next_state = state;
                end
            end
        end else begin
            // Falling states
            if (ground == 1'b1) begin
                // Ground returned: resume walking same direction
                next_state = {1'b0, state[0]};
            end else begin
                // Still falling, direction unchanged
                next_state = state;
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT; // Reset to walking left
        end else begin
            state <= next_state;
        end
    end

    // Moore outputs derived from state
    assign aaah       = state[1];          // falling bit
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] &  state[0];

endmodule