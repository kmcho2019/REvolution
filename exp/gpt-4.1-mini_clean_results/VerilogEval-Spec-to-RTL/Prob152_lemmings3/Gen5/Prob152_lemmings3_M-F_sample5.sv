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
    localparam WALKING = 2'd0;
    localparam FALLING = 2'd1;
    localparam DIGGING = 2'd2;

    // Registers for state and direction
    reg [1:0] state, next_state;
    reg       dir, next_dir; // 0 = left, 1 = right

    // One cycle delayed ground for edge detection
    reg ground_dly;

    // Edge signals derived synchronously
    wire ground_fell = (ground_dly == 1'b1) && (ground == 1'b0);
    wire ground_rise = (ground_dly == 1'b0) && (ground == 1'b1);

    // Logical OR of bumps
    wire bump = bump_left | bump_right;

    // Sequential logic: sample ground_dly and update state and direction
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALKING;
            dir        <= 1'b0; // start walking left
            ground_dly <= 1'b1; // assume ground present at reset
        end else begin
            ground_dly <= ground;
            state      <= next_state;
            dir        <= next_dir;
        end
    end

    // Next state and next direction logic (combinational)
    always @* begin
        // Defaults hold current values
        next_state = state;
        next_dir   = dir;

        case (state)
            WALKING: begin
                // Priority: fall > dig > bump
                if (ground_fell) begin
                    // Start falling when ground just lost
                    next_state = FALLING;
                    // direction unchanged
                end else if (dig && ground) begin
                    // Start digging only if dig=1 and ground present
                    next_state = DIGGING;
                    // direction unchanged
                end else if (bump) begin
                    // Bump handling with direction explicitly set by bump side:
                    // If both bump_left and bump_right are 1 simultaneously, toggle direction
                    if (bump_left & bump_right) begin
                        next_dir = ~dir;
                    end else if (bump_left) begin
                        next_dir = 1'b1; // walk right
                    end else if (bump_right) begin
                        next_dir = 1'b0; // walk left
                    end
                    next_state = WALKING;
                end else begin
                    // Remain walking same direction
                    next_state = WALKING;
                    next_dir = dir;
                end
            end

            FALLING: begin
                if (ground_rise) begin
                    // Landed on ground, resume walking same direction
                    next_state = WALKING;
                    // direction unchanged
                end else begin
                    // Continue falling
                    next_state = FALLING;
                    // direction unchanged
                end
                // bumps and dig ignored while falling
            end

            DIGGING: begin
                if (!ground) begin
                    // No ground means fall now
                    next_state = FALLING;
                    // direction unchanged
                end else begin
                    // Continue digging
                    next_state = DIGGING;
                    // direction unchanged
                end
                // bumps ignored while digging
            end

            default: begin
                next_state = WALKING;
                next_dir = 1'b0;
            end
        endcase
    end

    // Moore outputs: depend on registered state and direction
    assign walk_left  = (state == WALKING) && (dir == 1'b0);
    assign walk_right = (state == WALKING) && (dir == 1'b1);
    assign aaah       = (state == FALLING);
    assign digging    = (state == DIGGING);

endmodule