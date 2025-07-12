module TopModule (
    input  wire clk,
    input  wire areset,        // async reset, posedge active
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    input  wire dig,
    output wire walk_left,
    output wire walk_right,
    output wire aaah,
    output wire digging
);

    // State definition using enum for readability
    typedef enum logic [1:0] {
        WALKING = 2'd0,
        FALLING = 2'd1,
        DIGGING = 2'd2
    } state_t;

    state_t state, next_state;

    // Direction: 0=left, 1=right
    logic dir, next_dir;

    // Delayed ground for edge detection
    logic ground_dly;

    // Ground edge detection signals (combinational)
    wire ground_fell = (ground_dly == 1'b1) && (ground == 1'b0);
    wire ground_rise = (ground_dly == 1'b0) && (ground == 1'b1);

    // Sequential logic: state, direction and ground_dly updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALKING;
            dir        <= 1'b0;     // start walking left
            ground_dly <= 1'b1;     // assume ground present at reset
        end else begin
            state      <= next_state;
            dir        <= next_dir;
            ground_dly <= ground;
        end
    end

    // Next-state logic encapsulated in a combinational block
    always_comb begin
        // Default next values
        next_state = state;
        next_dir   = dir;

        case (state)
            WALKING: begin
                // Priority: fall > dig > bump
                if (ground_fell) begin
                    next_state = FALLING;
                    // direction unchanged
                end else if (dig && ground) begin
                    next_state = DIGGING;
                    // direction unchanged
                end else if (bump_left || bump_right) begin
                    // Explicit bump direction logic:
                    // both bumps: toggle direction
                    if (bump_left && bump_right) begin
                        next_dir = ~dir;
                    end else if (bump_left) begin
                        next_dir = 1'b1; // walk right
                    end else if (bump_right) begin
                        next_dir = 1'b0; // walk left
                    end
                    // remain walking
                    next_state = WALKING;
                end else begin
                    // No event, stay walking same direction
                    next_state = WALKING;
                    next_dir = dir;
                end
            end

            FALLING: begin
                if (ground_rise) begin
                    next_state = WALKING;
                    // keep direction
                end else begin
                    next_state = FALLING;
                    // direction unchanged
                end
            end

            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                    // direction unchanged
                end else begin
                    next_state = DIGGING;
                    // direction unchanged
                end
            end

            default: begin
                next_state = WALKING;
                next_dir = 1'b0;
            end
        endcase
    end

    // Moore outputs (based on registered state and direction)
    assign walk_left  = (state == WALKING) && (dir == 1'b0);
    assign walk_right = (state == WALKING) && (dir == 1'b1);
    assign aaah       = (state == FALLING);
    assign digging    = (state == DIGGING);

endmodule