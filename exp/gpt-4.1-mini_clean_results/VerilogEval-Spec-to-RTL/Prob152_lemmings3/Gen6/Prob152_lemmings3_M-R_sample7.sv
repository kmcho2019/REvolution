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
    localparam [1:0]
        WALKING = 2'd0,
        FALLING = 2'd1,
        DIGGING = 2'd2;

    // Direction encoding
    localparam DIR_LEFT  = 1'b0,
               DIR_RIGHT = 1'b1;

    // State registers
    reg [1:0] state, next_state;

    // Direction registers
    reg dir, next_dir;

    // Ground history shift register (2 flip-flops) for edge detection
    reg [1:0] ground_hist;

    // Update ground history at each clock
    always @(posedge clk or posedge areset) begin
        if (areset)
            ground_hist <= 2'b11; // assume ground present initially (1,1)
        else
            ground_hist <= {ground_hist[0], ground};
    end

    // Edge detection signals (from ground_hist)
    wire ground_fell = (ground_hist == 2'b10);  // was 1, now 0
    wire ground_rise = (ground_hist == 2'b01);  // was 0, now 1

    // Sequential update of state
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALKING;
        else
            state <= next_state;
    end

    // Sequential update of direction
    always @(posedge clk or posedge areset) begin
        if (areset)
            dir <= DIR_LEFT;
        else
            dir <= next_dir;
    end

    // Combinational next state and direction logic
    always @* begin
        // Defaults: hold current values
        next_state = state;
        next_dir   = dir;

        case (state)
            WALKING: begin
                // Priorities: fall > dig > bump
                if (ground_fell) begin
                    next_state = FALLING;
                    // direction unchanged
                end else if (dig && ground) begin
                    next_state = DIGGING;
                    // direction unchanged
                end else if (bump_left || bump_right) begin
                    // If both bumped, toggle direction
                    if (bump_left && bump_right)
                        next_dir = ~dir;
                    else if (bump_left)
                        next_dir = DIR_RIGHT;
                    else // bump_right only
                        next_dir = DIR_LEFT;
                    next_state = WALKING;
                end else begin
                    // no changes
                    next_state = WALKING;
                    next_dir = dir;
                end
            end

            FALLING: begin
                if (ground_rise) begin
                    next_state = WALKING;
                    // direction unchanged
                end else begin
                    next_state = FALLING;
                end
                // bumps and dig ignored while falling
            end

            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                    // direction unchanged
                end else begin
                    next_state = DIGGING;
                end
                // bumps ignored while digging
            end

            default: begin
                next_state = WALKING;
                next_dir = DIR_LEFT;
            end
        endcase
    end

    // Moore outputs depend only on current state and direction
    assign walk_left  = (state == WALKING) && (dir == DIR_LEFT);
    assign walk_right = (state == WALKING) && (dir == DIR_RIGHT);
    assign aaah       = (state == FALLING);
    assign digging    = (state == DIGGING);

endmodule