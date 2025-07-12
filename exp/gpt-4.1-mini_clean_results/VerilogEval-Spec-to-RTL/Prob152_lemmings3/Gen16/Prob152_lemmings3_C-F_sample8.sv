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

    // State encoding
    localparam [1:0]
        WALK = 2'd0,
        FALL = 2'd1,
        DIG  = 2'd2;

    reg [1:0] state, state_next;
    reg       dir, dir_next; // 0=left, 1=right

    // Bump detection gated to WALK mode
    wire bump = (state == WALK) && (bump_left || bump_right);

    always @(*) begin
        // Default next state and direction: hold current
        state_next = state;
        dir_next = dir;

        case (state)
            WALK: begin
                if (!ground) begin
                    // ground lost: start falling
                    state_next = FALL;
                    // direction unchanged
                end else if (dig) begin
                    // start digging
                    state_next = DIG;
                    // direction unchanged
                end else if (bump) begin
                    // bump detected, update direction
                    if (bump_left && bump_right)
                        dir_next = ~dir;
                    else if (bump_left)
                        dir_next = 1'b1; // walk right
                    else
                        dir_next = 1'b0; // walk left
                end
                // else remain walking same direction
            end

            FALL: begin
                if (ground) begin
                    // ground restored: go back to walking
                    state_next = WALK;
                    // direction unchanged
                end
                // else remain falling
            end

            DIG: begin
                if (!ground) begin
                    // reached edge, start falling
                    state_next = FALL;
                    // direction unchanged
                end
                // else continue digging
            end

            default: begin
                // Should not occur, reset to walk left
                state_next = WALK;
                dir_next = 1'b0;
            end
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 1'b0; // walk left on reset
        end else begin
            state <= state_next;
            dir <= dir_next;
        end
    end

    // Moore outputs derived from state and direction
    assign walk_left  = (state == WALK) && (dir == 1'b0);
    assign walk_right = (state == WALK) && (dir == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule