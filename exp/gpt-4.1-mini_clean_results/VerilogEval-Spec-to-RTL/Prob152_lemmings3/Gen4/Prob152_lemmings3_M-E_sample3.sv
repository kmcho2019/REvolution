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

    // State encoding (2 bits for clarity)
    localparam STATE_WALKING = 2'b00;
    localparam STATE_FALLING = 2'b01;
    localparam STATE_DIGGING = 2'b10;

    // Direction encoding
    localparam DIR_LEFT  = 1'b0;
    localparam DIR_RIGHT = 1'b1;

    reg [1:0] state;
    reg [1:0] next_state;

    reg       dir;
    reg       next_dir;

    reg       ground_prev;  // To detect edges on ground input

    // Detect edges on ground input (synchronously)
    wire ground_fell = (ground_prev == 1'b1) && (ground == 1'b0);
    wire ground_rose = (ground_prev == 1'b0) && (ground == 1'b1);

    wire bump = bump_left | bump_right;

    // Sequential logic: state, direction, and ground_prev registers
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state       <= STATE_WALKING;
            dir         <= DIR_LEFT;   // Start walking left
            ground_prev <= 1'b1;       // Assume on ground at reset
        end else begin
            state       <= next_state;
            dir         <= next_dir;
            ground_prev <= ground;
        end
    end

    // Next state and direction logic - Moore FSM
    always_comb begin
        // Defaults: hold current values
        next_state = state;
        next_dir   = dir;

        case (state)
            STATE_WALKING: begin
                // Priority order: fall > dig > bump

                if (ground_fell) begin
                    // Fell off ground => start falling
                    next_state = STATE_FALLING;
                    // direction unchanged
                end else if (dig && ground) begin
                    // Start digging only if on ground and walking
                    next_state = STATE_DIGGING;
                    // direction unchanged
                end else if (bump) begin
                    // Switch direction on any bump while walking (and not falling/digging)
                    next_dir = ~dir;
                    next_state = STATE_WALKING;
                end else begin
                    // Continue walking same direction
                    next_state = STATE_WALKING;
                    next_dir = dir;
                end
            end

            STATE_FALLING: begin
                if (ground_rose) begin
                    // Landed on ground, resume walking, keep direction
                    next_state = STATE_WALKING;
                    // direction unchanged
                end else begin
                    // Still falling
                    next_state = STATE_FALLING;
                    // direction unchanged
                end
                // bumps and dig inputs ignored while falling
            end

            STATE_DIGGING: begin
                if (ground_fell) begin
                    // Ground lost while digging => start falling
                    next_state = STATE_FALLING;
                    // direction unchanged
                end else if (ground) begin
                    // Continue digging while ground present
                    next_state = STATE_DIGGING;
                    // direction unchanged
                end else begin
                    // Defensive default, should not occur, but stay digging anyway
                    next_state = STATE_DIGGING;
                end
                // bumps ignored while digging
            end

            default: begin
                // Safety fallback reset to walking left
                next_state = STATE_WALKING;
                next_dir   = DIR_LEFT;
            end
        endcase
    end

    // Outputs are Moore: depend only on current state and direction
    assign walk_left  = (state == STATE_WALKING) && (dir == DIR_LEFT);
    assign walk_right = (state == STATE_WALKING) && (dir == DIR_RIGHT);
    assign aaah       = (state == STATE_FALLING);
    assign digging    = (state == STATE_DIGGING);

endmodule