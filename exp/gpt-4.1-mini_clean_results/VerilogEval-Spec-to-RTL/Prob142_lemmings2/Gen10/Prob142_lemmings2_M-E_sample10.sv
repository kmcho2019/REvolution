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

    // State encoding
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING    = 2'b10;

    reg [1:0] state, next_state;
    reg [1:0] saved_direction; // remembers walking direction before falling (WALK_LEFT or WALK_RIGHT)

    // Combine bumps for convenience
    wire bump = bump_left | bump_right;
    wire both_bumps = bump_left & bump_right;

    // Next state logic (Moore FSM)
    always @(*) begin
        next_state = state;
        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump) begin
                    // On any bump, switch direction to right
                    // Both bumps or bump_left bump_right: same effect, walk right
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump) begin
                    // On any bump, switch direction to left
                    next_state = WALK_LEFT;
                end
            end
            FALLING: begin
                if (ground) begin
                    // Restore walking direction saved before falling
                    next_state = saved_direction;
                end
                // Ignore bumps while falling
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Sequential state update and save direction when entering FALLING
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            saved_direction <= WALK_LEFT;
        end else begin
            // Save current walking direction when starting to fall
            if ((state == WALK_LEFT || state == WALK_RIGHT) && next_state == FALLING) begin
                saved_direction <= state;
            end
            state <= next_state;
        end
    end

    // Output logic (Moore)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule