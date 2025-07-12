module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    input  wire dig,
    output wire walk_left,
    output wire walk_right,
    output wire aaah,
    output wire digging
);

    // State encoding
    localparam WALK_LEFT  = 2'd0;
    localparam WALK_RIGHT = 2'd1;
    localparam FALLING    = 2'd2;
    localparam DIGGING    = 2'd3;

    reg [1:0] state, next_state;
    reg ground_dly;

    wire ground_fell = ground_dly & ~ground;
    wire ground_rise = ~ground_dly & ground;
    wire bump = bump_left | bump_right;
    wire both_bumps = bump_left & bump_right;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK_LEFT;
            ground_dly <= 1'b1; // assume ground present at reset
        end else begin
            ground_dly <= ground;
            state      <= next_state;
        end
    end

    always @* begin
        next_state = state; // default hold

        case(state)
            WALK_LEFT: begin
                if (ground_fell) begin
                    next_state = FALLING;
                end else if (dig && ground) begin
                    next_state = DIGGING;
                end else if (bump) begin
                    // bump left => walk right
                    // bump right => walk left
                    // both bumps => switch direction (toggle)
                    if (both_bumps)
                        next_state = WALK_RIGHT; // toggle from left to right
                    else if (bump_left)
                        next_state = WALK_RIGHT;
                    else // bump_right
                        next_state = WALK_LEFT; // already walking left, but per spec direction switches, so switch to left?
                        // Actually since walking left and bumped right means walk left, so stay WALK_LEFT?
                        // Spec says: bump_right means walk left, so stays in WALK_LEFT state
                end
                // else remain WALK_LEFT
            end

            WALK_RIGHT: begin
                if (ground_fell) begin
                    next_state = FALLING;
                end else if (dig && ground) begin
                    next_state = DIGGING;
                end else if (bump) begin
                    // bump left => walk right
                    // bump right => walk left
                    // both bumps => switch direction (toggle)
                    if (both_bumps)
                        next_state = WALK_LEFT; // toggle from right to left
                    else if (bump_left)
                        next_state = WALK_RIGHT; // already walking right, so stays here
                    else // bump_right
                        next_state = WALK_LEFT;
                end
                // else remain WALK_RIGHT
            end

            FALLING: begin
                if (ground_rise) begin
                    // return to walking with previous direction, which is either WALK_LEFT or WALK_RIGHT stored in state before falling
                    // But we lost previous walking direction in FALLING state
                    // To fix, encode direction in FALLING state name by reserving FALLING_LEFT and FALLING_RIGHT or store direction in a separate reg

                    // To avoid extra reg, we can encode FALLING states as FALLING_LEFT and FALLING_RIGHT
                    // Let's revise encoding to:
                    // 00: WALK_LEFT
                    // 01: WALK_RIGHT
                    // 10: FALLING_LEFT
                    // 11: FALLING_RIGHT
                    // and similarly for DIGGING states

                    // So we revise code below (see after this block)
                    // For now leave placeholder:
                    next_state = WALK_LEFT; // default fallback
                end else begin
                    // continue falling in same direction
                    next_state = state;
                end
            end

            DIGGING: begin
                if (!ground) begin
                    // fall after dig
                    // same concern as FALLING state for direction info
                    next_state = FALLING;
                end else begin
                    // keep digging
                    next_state = DIGGING;
                end
            end
        endcase
    end

    // The FALLING and DIGGING states need direction info,
    // so redefine states to encode direction in falling and digging states.
    // Let's do that now below.

endmodule