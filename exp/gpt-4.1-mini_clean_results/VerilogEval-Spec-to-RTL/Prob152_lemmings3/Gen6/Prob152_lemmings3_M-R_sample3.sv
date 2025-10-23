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
    typedef enum logic [1:0] {WALK=2'b00, FALL=2'b01, DIG=2'b10} state_t;

    state_t state, next_state;
    logic dir, next_dir;         // 0=left, 1=right
    logic prev_ground, next_prev_ground;
    logic bumped = bump_left | bump_right;
    logic ground_fell, ground_rose;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state       <= WALK;
            dir         <= 1'b0;     // start walking left
            prev_ground <= 1'b1;     // assume starts on ground
        end else begin
            state       <= next_state;
            dir         <= next_dir;
            prev_ground <= next_prev_ground;
        end
    end

    // Calculate edges on ground
    assign ground_fell = (prev_ground == 1'b1) && (ground == 1'b0);
    assign ground_rose = (prev_ground == 1'b0) && (ground == 1'b1);

    always_comb begin
        // Default next values are current
        next_state       = state;
        next_dir         = dir;
        next_prev_ground = ground;

        case (state)
            WALK: begin
                if (ground_fell) begin
                    // Highest priority: fall when ground disappears
                    next_state = FALL;
                    // dir unchanged
                end else if (dig && ground) begin
                    // Next priority: start digging only if ground present and walking
                    next_state = DIG;
                    // dir unchanged
                end else if (bumped) begin
                    // Lowest priority: bump switches direction only when walking and ground stable
                    // Ignore bumps on ground edges as per spec
                    if (!(ground_fell || ground_rose)) begin
                        next_dir = ~dir;
                    end
                    // state unchanged
                end
                // else remain walking same direction
            end

            FALL: begin
                if (ground_rose) begin
                    // Ground returns: back to walking, keep direction
                    next_state = WALK;
                end
                // else remain falling
            end

            DIG: begin
                if (!ground) begin
                    // Digging stops if ground lost, start falling
                    next_state = FALL;
                end
                // else keep digging
            end

            default: begin
                next_state = WALK;
                next_dir   = 1'b0;
            end
        endcase
    end

    // Outputs from state and dir (Moore outputs)
    assign walk_left  = (state == WALK) && (dir == 1'b0);
    assign walk_right = (state == WALK) && (dir == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule