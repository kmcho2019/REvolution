module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding
    localparam WALK_LEFT  = 3'b000;
    localparam WALK_RIGHT = 3'b001;
    localparam FALL_LEFT  = 3'b010;
    localparam FALL_RIGHT = 3'b011;
    localparam DIG_LEFT   = 3'b100;
    localparam DIG_RIGHT  = 3'b101;
    localparam SPLAT      = 3'b110;

    reg [2:0] state, next_state;
    reg [4:0] fall_count, next_fall_count; // count falling cycles (max 31)

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
        end
    end

    // Determine next state and next fall_count
    always @(*) begin
        // Defaults
        next_state = state;
        next_fall_count = fall_count;

        case(state)
            // Walking left
            WALK_LEFT: begin
                if (ground == 1'b0) begin
                    // ground gone: fall left
                    next_state = FALL_LEFT;
                    next_fall_count = 5'd1;
                end else if (dig == 1'b1) begin
                    // start digging
                    next_state = DIG_LEFT;
                    next_fall_count = 5'd0;
                end else begin
                    // check bumps to switch direction
                    if (bump_left == 1'b1 || bump_right == 1'b1) begin
                        next_state = WALK_RIGHT;
                        next_fall_count = 5'd0;
                    end else begin
                        next_state = WALK_LEFT;
                        next_fall_count = 5'd0;
                    end
                end
            end

            // Walking right
            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    // ground gone: fall right
                    next_state = FALL_RIGHT;
                    next_fall_count = 5'd1;
                end else if (dig == 1'b1) begin
                    // start digging
                    next_state = DIG_RIGHT;
                    next_fall_count = 5'd0;
                end else begin
                    // check bumps to switch direction
                    if (bump_left == 1'b1 || bump_right == 1'b1) begin
                        next_state = WALK_LEFT;
                        next_fall_count = 5'd0;
                    end else begin
                        next_state = WALK_RIGHT;
                        next_fall_count = 5'd0;
                    end
                end
            end

            // Falling left
            FALL_LEFT: begin
                if (ground == 1'b1) begin
                    // landed
                    if (fall_count > 5'd20) begin
                        // splat if fell too long
                        next_state = SPLAT;
                        next_fall_count = 5'd0;
                    end else begin
                        // resume walking left
                        next_state = WALK_LEFT;
                        next_fall_count = 5'd0;
                    end
                end else begin
                    // still falling, increment fall_count
                    next_state = FALL_LEFT;
                    if (fall_count < 5'd31)
                        next_fall_count = fall_count + 5'd1;
                    else
                        next_fall_count = fall_count; // saturate at max
                end
            end

            // Falling right
            FALL_RIGHT: begin
                if (ground == 1'b1) begin
                    // landed
                    if (fall_count > 5'd20) begin
                        // splat if fell too long
                        next_state = SPLAT;
                        next_fall_count = 5'd0;
                    end else begin
                        // resume walking right
                        next_state = WALK_RIGHT;
                        next_fall_count = 5'd0;
                    end
                end else begin
                    // still falling, increment fall_count
                    next_state = FALL_RIGHT;
                    if (fall_count < 5'd31)
                        next_fall_count = fall_count + 5'd1;
                    else
                        next_fall_count = fall_count;
                end
            end

            // Digging left
            DIG_LEFT: begin
                if (ground == 1'b0) begin
                    // ground gone while digging: start falling left
                    next_state = FALL_LEFT;
                    next_fall_count = 5'd1;
                end else begin
                    // continue digging
                    next_state = DIG_LEFT;
                    next_fall_count = 5'd0;
                end
            end

            // Digging right
            DIG_RIGHT: begin
                if (ground == 1'b0) begin
                    // ground gone while digging: start falling right
                    next_state = FALL_RIGHT;
                    next_fall_count = 5'd1;
                end else begin
                    // continue digging
                    next_state = DIG_RIGHT;
                    next_fall_count = 5'd0;
                end
            end

            // Splat (dead)
            SPLAT: begin
                next_state = SPLAT;
                next_fall_count = 5'd0;
            end

            default: begin
                next_state = WALK_LEFT;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Outputs depend on state (Moore FSM)
    always @(*) begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        digging    = 1'b0;

        case(state)
            WALK_LEFT:  walk_left  = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALL_LEFT,
            FALL_RIGHT: aaah       = 1'b1;
            DIG_LEFT,
            DIG_RIGHT:  digging    = 1'b1;
            SPLAT: begin
                // all outputs zero
            end
        endcase
    end

endmodule