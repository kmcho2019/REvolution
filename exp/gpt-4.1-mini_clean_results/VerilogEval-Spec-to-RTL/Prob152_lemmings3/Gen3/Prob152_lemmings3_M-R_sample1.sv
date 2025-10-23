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

    // Ground delayed for edge detection (2-stage synchronizer style)
    reg ground_d1, ground_d2;

    wire ground_fell = (ground_d2 == 1'b1) && (ground_d1 == 1'b0); // ground fell on last cycle
    wire ground_rise = (ground_d2 == 1'b0) && (ground_d1 == 1'b1); // ground rose on last cycle

    wire bump = bump_left | bump_right;

    // Sample ground in two flip-flops to create stable delayed signals for edge detection
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            ground_d1 <= 1'b1;
            ground_d2 <= 1'b1;
        end else begin
            ground_d1 <= ground;
            ground_d2 <= ground_d1;
        end
    end

    // State and direction registers with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING;
            dir   <= 1'b0; // start walking left
        end else begin
            state <= next_state;
            dir   <= next_dir;
        end
    end

    // Next state logic
    always_comb begin
        // Defaults: hold current values
        next_state = state;
        next_dir   = dir;

        case (state)
            WALKING: begin
                // Priority: fall > dig > bump
                // Detect if ground fell this cycle (looking at edge signals)
                if (ground_fell || (ground_d1 == 1'b0 && ground == 1'b0)) begin
                    // If ground just lost or currently no ground, start falling
                    next_state = FALLING;
                    // direction unchanged
                end else if (dig && ground) begin
                    // Dig command only valid when walking on ground
                    next_state = DIGGING;
                    // direction unchanged
                end else if (bump && !ground_fell && !ground_rise) begin
                    // Switch direction on bump if no ground transition this cycle
                    next_dir = ~dir;
                    next_state = WALKING;
                end else begin
                    // remain walking in same direction
                    next_state = WALKING;
                    // direction unchanged
                end
            end

            FALLING: begin
                if (ground_rise) begin
                    // Landed: resume walking same direction
                    next_state = WALKING;
                    // direction unchanged
                end else begin
                    // Still falling
                    next_state = FALLING;
                    // direction unchanged
                end
                // bumps ignored
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
                // bumps ignored
            end

            default: begin
                // Safety fallback
                next_state = WALKING;
                next_dir = 1'b0;
            end
        endcase
    end

    // Outputs - Moore FSM outputs depend only on state and direction
    assign walk_left  = (state == WALKING) && (dir == 1'b0);
    assign walk_right = (state == WALKING) && (dir == 1'b1);
    assign aaah       = (state == FALLING);
    assign digging    = (state == DIGGING);

endmodule