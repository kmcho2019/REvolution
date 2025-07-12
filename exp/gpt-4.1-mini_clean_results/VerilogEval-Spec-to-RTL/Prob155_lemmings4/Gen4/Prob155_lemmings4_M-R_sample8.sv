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

    // State encoding using localparams (one-hot style)
    localparam WALK = 2'd0;
    localparam FALL = 2'd1;
    localparam DIG  = 2'd2;
    localparam SPLAT= 2'd3;

    localparam DIR_LEFT  = 1'b0;
    localparam DIR_RIGHT = 1'b1;

    reg [1:0] state, next_state;
    reg dir, next_dir;
    reg [4:0] fall_count, next_fall_count;

    wire bump = bump_left | bump_right;

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= DIR_LEFT;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            dir <= next_dir;
            fall_count <= next_fall_count;
        end
    end

    // Next state logic
    always @(*) begin
        // Default to current values
        next_state = state;
        case (state)
            WALK: begin
                if (!ground)           next_state = FALL;
                else if (dig)          next_state = DIG;
                else                   next_state = WALK;
            end
            FALL: begin
                if (ground)            next_state = (fall_count > 5'd20) ? SPLAT : WALK;
                else                   next_state = FALL;
            end
            DIG: begin
                if (!ground)           next_state = FALL;
                else                   next_state = DIG;
            end
            SPLAT: begin
                next_state = SPLAT;
            end
            default: next_state = WALK;
        endcase
    end

    // Next direction logic
    always @(*) begin
        next_dir = dir; // default hold

        // Direction changes only when walking on ground and bump occurs
        if (state == WALK && ground && !dig) begin
            // If bumped on either side or both, change direction accordingly
            if (bump_left && bump_right) next_dir = ~dir;
            else if (bump_left)          next_dir = DIR_RIGHT;
            else if (bump_right)         next_dir = DIR_LEFT;
        end
        // Direction holds otherwise
    end

    // Next fall count logic
    always @(*) begin
        next_fall_count = fall_count;

        if (state == FALL) begin
            if (!ground) begin
                // Saturate at 31
                next_fall_count = (fall_count < 5'd31) ? fall_count + 1 : fall_count;
            end else begin
                next_fall_count = 5'd0;
            end
        end else begin
            next_fall_count = 5'd0;
        end
    end

    // Outputs (Moore machine)
    assign walk_left  = (state == WALK) && (dir == DIR_LEFT);
    assign walk_right = (state == WALK) && (dir == DIR_RIGHT);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule