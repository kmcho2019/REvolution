module TopModule (
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
localparam WALK_LEFT  = 3'd0;
localparam WALK_RIGHT = 3'd1;
localparam FALL_LEFT  = 3'd2;
localparam FALL_RIGHT = 3'd3;
localparam DIG_LEFT   = 3'd4;
localparam DIG_RIGHT  = 3'd5;
localparam SPLAT      = 3'd6;

reg [2:0] state, next_state;
reg [4:0] fall_count, next_fall_count;

// Asynchronous reset and state, fall_count register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 5'd0;
    end else begin
        state <= next_state;
        fall_count <= next_fall_count;
    end
end

// Combinational next state logic and fall_count update
always @(*) begin
    // Defaults
    next_state = state;
    next_fall_count = fall_count;

    case (state)
    // Walking left
    WALK_LEFT: begin
        if (ground == 1'b0) begin
            // Fall start
            next_state = FALL_LEFT;
            next_fall_count = 5'd1;
        end else if (dig == 1'b1) begin
            // Dig start
            next_state = DIG_LEFT;
            next_fall_count = 5'd0;
        end else begin
            // Walking, check bump
            if (bump_left || bump_right) begin
                // Switch direction on bump left or right (or both)
                next_state = WALK_RIGHT;
            end else begin
                // Stay walking left
                next_state = WALK_LEFT;
            end
            next_fall_count = 5'd0;
        end
    end

    // Walking right
    WALK_RIGHT: begin
        if (ground == 1'b0) begin
            next_state = FALL_RIGHT;
            next_fall_count = 5'd1;
        end else if (dig == 1'b1) begin
            next_state = DIG_RIGHT;
            next_fall_count = 5'd0;
        end else begin
            if (bump_left || bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
            next_fall_count = 5'd0;
        end
    end

    // Falling left
    FALL_LEFT: begin
        if (ground == 1'b0) begin
            // Still falling, increment counter (max 31, safe for >20)
            if (fall_count < 5'd31)
                next_fall_count = fall_count + 5'd1;
            else
                next_fall_count = fall_count;
            next_state = FALL_LEFT;
        end else begin
            // Ground hit
            if (fall_count > 5'd20) begin
                // splatter
                next_state = SPLAT;
                next_fall_count = 5'd0;
            end else begin
                next_state = WALK_LEFT;
                next_fall_count = 5'd0;
            end
        end
    end

    // Falling right
    FALL_RIGHT: begin
        if (ground == 1'b0) begin
            if (fall_count < 5'd31)
                next_fall_count = fall_count + 5'd1;
            else
                next_fall_count = fall_count;
            next_state = FALL_RIGHT;
        end else begin
            if (fall_count > 5'd20) begin
                next_state = SPLAT;
                next_fall_count = 5'd0;
            end else begin
                next_state = WALK_RIGHT;
                next_fall_count = 5'd0;
            end
        end
    end

    // Digging left
    DIG_LEFT: begin
        if (ground == 1'b1) begin
            // continue digging
            next_state = DIG_LEFT;
            next_fall_count = 5'd0;
        end else begin
            // ground lost, start falling left
            next_state = FALL_LEFT;
            next_fall_count = 5'd1;
        end
    end

    // Digging right
    DIG_RIGHT: begin
        if (ground == 1'b1) begin
            next_state = DIG_RIGHT;
            next_fall_count = 5'd0;
        end else begin
            next_state = FALL_RIGHT;
            next_fall_count = 5'd1;
        end
    end

    // Splatter: terminal state
    SPLAT: begin
        next_state = SPLAT;
        next_fall_count = 5'd0;
    end

    default: begin
        // Safety fallback
        next_state = WALK_LEFT;
        next_fall_count = 5'd0;
    end
    endcase
end

// Moore outputs depend on state
assign walk_left  = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule