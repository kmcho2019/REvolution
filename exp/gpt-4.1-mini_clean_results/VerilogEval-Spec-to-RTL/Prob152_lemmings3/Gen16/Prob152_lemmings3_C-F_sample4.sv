module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    localparam WALK = 2'd0,
               FALL = 2'd1,
               DIG  = 2'd2;

    reg [1:0] state, state_next;
    reg       dir, dir_next;

    // Combinational next-state and next-dir logic
    always @(*) begin
        // Defaults to hold current state/direction
        state_next = state;
        dir_next   = dir;

        case (state)
            WALK: begin
                if (!ground) begin
                    // Highest priority: falling when no ground
                    state_next = FALL;
                    // direction unchanged during fall
                end else if (dig) begin
                    // Next priority: dig if dig=1 and on ground and walking
                    state_next = DIG;
                    // direction unchanged during dig
                end else begin
                    // Finally: bump direction switching only when walking and ground
                    // Bump on left means start walking right; bump on right means start walking left
                    // If bumped on both sides, toggle direction
                    if (bump_left && bump_right)
                        dir_next = ~dir;
                    else if (bump_left)
                        dir_next = 1'b1; // walk right
                    else if (bump_right)
                        dir_next = 1'b0; // walk left
                    // else no direction change
                end
            end

            FALL: begin
                if (ground) begin
                    // Back to walking when ground reappears
                    state_next = WALK;
                    // direction unchanged
                end
            end

            DIG: begin
                if (!ground) begin
                    // Transition to falling if no ground while digging
                    state_next = FALL;
                    // direction unchanged
                end
                // else keep digging
            end

            default: begin
                // Defensive default state reset to WALK
                state_next = WALK;
                dir_next   = 1'b0;
            end
        endcase
    end

    // Sequential state and direction registers with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir   <= 1'b0; // start walking left
        end else begin
            state <= state_next;
            dir   <= dir_next;
        end
    end

    // Moore outputs based on current state and direction
    assign walk_left  = (state == WALK) && (dir == 1'b0);
    assign walk_right = (state == WALK) && (dir == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule