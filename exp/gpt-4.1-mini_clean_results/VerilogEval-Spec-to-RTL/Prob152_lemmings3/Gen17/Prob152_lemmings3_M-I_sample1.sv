module TopModule(
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
    localparam WALK = 2'd0;
    localparam FALL = 2'd1;
    localparam DIG  = 2'd2;

    reg [1:0] state, next_state;
    reg dir, next_dir; // 0=left, 1=right

    // Sequential state and direction update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 1'b0; // walk left on reset
        end else begin
            state <= next_state;
            dir <= next_dir;
        end
    end

    // Next-state and direction logic
    always @(*) begin
        // Default assignments: hold current values
        next_state = state;
        next_dir = dir;

        case (state)
            FALL: begin
                if (ground)
                    next_state = WALK;
            end
            DIG: begin
                if (!ground)
                    next_state = FALL;
            end
            WALK: begin
                if (!ground)
                    next_state = FALL;
                else if (dig)
                    next_state = DIG;
                else begin
                    // Change direction on bumps if walking
                    if (bump_left && bump_right)
                        next_dir = ~dir;
                    else if (bump_left)
                        next_dir = 1'b1; // walk right
                    else if (bump_right)
                        next_dir = 1'b0; // walk left
                end
            end
            default: begin
                next_state = WALK;
                next_dir = 1'b0;
            end
        endcase
    end

    assign walk_left  = (state == WALK) && (dir == 1'b0);
    assign walk_right = (state == WALK) && (dir == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule