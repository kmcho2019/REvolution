module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding
    localparam WALK_LEFT   = 3'd0;
    localparam WALK_RIGHT  = 3'd1;
    localparam FALL_LEFT   = 3'd2;
    localparam FALL_RIGHT  = 3'd3;
    localparam DIG_LEFT    = 3'd4;
    localparam DIG_RIGHT   = 3'd5;
    localparam SPLATTERED  = 3'd6;

    reg [2:0] state, next_state;
    reg [4:0] fall_count, next_fall_count; // counts up to >20
    
    // Helper signals for bumps and switching direction
    wire bumped = bump_left | bump_right;
    wire bumped_left = bump_left;
    wire bumped_right = bump_right;
    
    // Determine direction for walking/falling/digging states
    function is_walking_left;
        input [2:0] s;
        begin
            is_walking_left = (s == WALK_LEFT) || (s == FALL_LEFT) || (s == DIG_LEFT);
        end
    endfunction

    // Next state logic
    always @(*) begin
        // default next state and fall count
        next_state = state;
        next_fall_count = fall_count;

        case(state)
            SPLATTERED: begin
                // stays splattered forever until reset
                next_state = SPLATTERED;
                next_fall_count = 0;
            end

            // Walking left
            WALK_LEFT: begin
                // Priority: fall > dig > bump
                if (!ground) begin
                    // Start falling left
                    next_state = FALL_LEFT;
                    next_fall_count = 1;
                end else if (dig) begin
                    // Start digging left
                    next_state = DIG_LEFT;
                    next_fall_count = 0;
                end else if (bumped) begin
                    // Switch direction to right if bumped left or right or both
                    next_state = WALK_RIGHT;
                    next_fall_count = 0;
                end else begin
                    next_state = WALK_LEFT;
                    next_fall_count = 0;
                end
            end

            // Walking right
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                    next_fall_count = 1;
                end else if (dig) begin
                    next_state = DIG_RIGHT;
                    next_fall_count = 0;
                end else if (bumped) begin
                    // switch direction to left
                    next_state = WALK_LEFT;
                    next_fall_count = 0;
                end else begin
                    next_state = WALK_RIGHT;
                    next_fall_count = 0;
                end
            end

            // Falling left
            FALL_LEFT: begin
                if (ground) begin
                    // Landing after falling
                    if (fall_count > 20) begin
                        // splatter
                        next_state = SPLATTERED;
                        next_fall_count = 0;
                    end else begin
                        // resume walking left
                        next_state = WALK_LEFT;
                        next_fall_count = 0;
                    end
                end else begin
                    // continue falling
                    next_state = FALL_LEFT;
                    // increment fall_count with saturation at max 31 (5 bits)
                    if (fall_count < 31)
                        next_fall_count = fall_count + 1;
                    else
                        next_fall_count = fall_count;
                end
            end

            // Falling right
            FALL_RIGHT: begin
                if (ground) begin
                    if (fall_count > 20) begin
                        next_state = SPLATTERED;
                        next_fall_count = 0;
                    end else begin
                        next_state = WALK_RIGHT;
                        next_fall_count = 0;
                    end
                end else begin
                    next_state = FALL_RIGHT;
                    if (fall_count < 31)
                        next_fall_count = fall_count + 1;
                    else
                        next_fall_count = fall_count;
                end
            end

            // Digging left
            DIG_LEFT: begin
                if (!ground) begin
                    // Digging ended, start falling left
                    next_state = FALL_LEFT;
                    next_fall_count = 1;
                end else begin
                    // Continue digging left, bumps and dig input ignored
                    next_state = DIG_LEFT;
                    next_fall_count = 0;
                end
            end

            // Digging right
            DIG_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                    next_fall_count = 1;
                end else begin
                    next_state = DIG_RIGHT;
                    next_fall_count = 0;
                end
            end

            default: begin
                // Should not happen, go to walk_left safe
                next_state = WALK_LEFT;
                next_fall_count = 0;
            end
        endcase
    end

    // State and fall_count registers with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 0;
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
        end
    end

    // Outputs: Moore type, depend only on current state
    assign walk_left  = (state == WALK_LEFT) || (state == DIG_LEFT);
    assign walk_right = (state == WALK_RIGHT) || (state == DIG_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule