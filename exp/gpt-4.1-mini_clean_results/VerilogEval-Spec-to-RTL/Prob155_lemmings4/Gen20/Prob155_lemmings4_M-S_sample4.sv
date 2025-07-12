module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding (3 bits)
    // 0 = walk left
    // 1 = walk right
    // 2 = digging (direction stored in dir reg)
    // 3 = falling (direction stored in dir reg)
    // 4 = splatted (no outputs)
    localparam W_LEFT  = 3'd0;
    localparam W_RIGHT = 3'd1;
    localparam DIG     = 3'd2;
    localparam FALL    = 3'd3;
    localparam SPLAT   = 3'd4;

    reg [2:0] state, next_state;
    reg direction, next_direction; // 0=left,1=right for dig/fall modes
    reg [4:0] fall_timer, next_fall_timer;

    // Async reset on posedge
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= W_LEFT;
            direction <= 1'b0; // left
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    always @(*) begin
        // Defaults: hold current state
        next_state = state;
        next_direction = direction;
        next_fall_timer = 5'd0;

        case (state)
            W_LEFT, W_RIGHT: begin
                // Walking states store direction implicitly
                // state==W_LEFT => direction=0
                // state==W_RIGHT => direction=1
                if (!ground) begin
                    next_state = FALL;
                    next_direction = (state == W_RIGHT) ? 1'b1 : 1'b0;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    next_state = DIG;
                    next_direction = (state == W_RIGHT) ? 1'b1 : 1'b0;
                end else if (bump_left || bump_right) begin
                    // Switch walking direction on bump(s)
                    if (bump_left && bump_right) begin
                        // Both bumps toggle direction
                        if (state == W_LEFT) next_state = W_RIGHT;
                        else if (state == W_RIGHT) next_state = W_LEFT;
                    end else if (bump_left) begin
                        next_state = W_RIGHT;
                    end else begin // bump_right
                        next_state = W_LEFT;
                    end
                end else begin
                    // Stay in current walk direction
                    next_state = state;
                end
            end

            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                    next_direction = direction;
                    next_fall_timer = 5'd1;
                end else begin
                    // Continue digging, ignore bumps and dig input
                    next_state = DIG;
                    next_direction = direction;
                end
            end

            FALL: begin
                if (ground) begin
                    if (fall_timer > 5'd20)
                        next_state = SPLAT;
                    else
                        // Return to walking in original direction
                        next_state = (direction == 1'b0) ? W_LEFT : W_RIGHT;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else begin
                    next_state = FALL;
                    next_direction = direction;
                    next_fall_timer = fall_timer + 1'b1;
                end
            end

            SPLAT: begin
                // Remain splatted forever, no outputs
                next_state = SPLAT;
                next_direction = direction;
                next_fall_timer = 5'd0;
            end

            default: begin
                // Defensive reset
                next_state = W_LEFT;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Outputs as Moore outputs
    assign walk_left  = (state == W_LEFT);
    assign walk_right = (state == W_RIGHT);
    assign digging    = (state == DIG);
    assign aaah       = (state == FALL);

endmodule