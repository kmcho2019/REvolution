module TopModule (
    input  clk,
    input  areset,       // asynchronous positive edge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding with direction included (3 bits)
    // Walking, Falling, Digging each have left/right versions
    localparam [2:0]
        WALK_LEFT  = 3'd0,
        WALK_RIGHT = 3'd1,
        FALL_LEFT  = 3'd2,
        FALL_RIGHT = 3'd3,
        DIG_LEFT   = 3'd4,
        DIG_RIGHT  = 3'd5,
        SPLAT      = 3'd6;

    reg [2:0] state, next_state;
    reg [4:0] fall_count, next_fall_count;

    // Combinational next state and fall count logic
    always @(*) begin
        next_state = state;
        next_fall_count = fall_count;

        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALL_LEFT;
                    next_fall_count = 5'd1;
                end else if (dig) begin
                    next_state = DIG_LEFT;
                    next_fall_count = 5'd0;
                end else if (bump_left | bump_right) begin
                    // bump_any reverses direction
                    next_state = WALK_RIGHT;
                    next_fall_count = 5'd0;
                end else begin
                    next_state = WALK_LEFT;
                    next_fall_count = 5'd0;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                    next_fall_count = 5'd1;
                end else if (dig) begin
                    next_state = DIG_RIGHT;
                    next_fall_count = 5'd0;
                end else if (bump_left | bump_right) begin
                    next_state = WALK_LEFT;
                    next_fall_count = 5'd0;
                end else begin
                    next_state = WALK_RIGHT;
                    next_fall_count = 5'd0;
                end
            end

            FALL_LEFT: begin
                if (!ground) begin
                    next_state = FALL_LEFT;
                    if (fall_count < 5'd31)
                        next_fall_count = fall_count + 1;
                    else
                        next_fall_count = fall_count;
                end else begin
                    if (fall_count > 5'd20)
                        next_state = SPLAT;
                    else
                        next_state = WALK_LEFT;
                    next_fall_count = 5'd0;
                end
            end

            FALL_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                    if (fall_count < 5'd31)
                        next_fall_count = fall_count + 1;
                    else
                        next_fall_count = fall_count;
                end else begin
                    if (fall_count > 5'd20)
                        next_state = SPLAT;
                    else
                        next_state = WALK_RIGHT;
                    next_fall_count = 5'd0;
                end
            end

            DIG_LEFT: begin
                if (!ground) begin
                    next_state = FALL_LEFT;
                    next_fall_count = 5'd1;
                end else begin
                    next_state = DIG_LEFT;
                    next_fall_count = 5'd0;
                end
            end

            DIG_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                    next_fall_count = 5'd1;
                end else begin
                    next_state = DIG_RIGHT;
                    next_fall_count = 5'd0;
                end
            end

            SPLAT: begin
                next_state = SPLAT;
                next_fall_count = 5'd0;
            end

            default: begin
                // Recover to walking left on unknown state
                next_state = WALK_LEFT;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // State register with asynchronous reset on posedge areset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
        end
    end

    // Output logic
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT)  || (state == DIG_RIGHT);

endmodule