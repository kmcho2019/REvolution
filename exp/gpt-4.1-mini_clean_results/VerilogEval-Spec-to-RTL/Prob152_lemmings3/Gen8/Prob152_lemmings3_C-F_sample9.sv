module TopModule(
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

    // Mode encoding (2-bit)
    localparam WALKING = 2'd0;
    localparam FALLING = 2'd1;
    localparam DIGGING = 2'd2;

    reg [1:0] mode, next_mode;
    reg dir, next_dir;        // direction: 0=left, 1=right
    reg prev_ground;

    // Sequential logic: registers update on clock or async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode        <= WALKING;
            dir         <= 1'b0;    // start walking left
            prev_ground <= 1'b1;    // assume stable on ground at reset
        end else begin
            mode        <= next_mode;
            dir         <= next_dir;
            prev_ground <= ground;
        end
    end

    // Detect stable ground (ground held high for two cycles)
    wire stable_ground = ground & prev_ground;

    // Combinational next state and direction logic
    always @(*) begin
        // defaults hold current values
        next_mode = mode;
        next_dir  = dir;

        case (mode)
            WALKING: begin
                // Priority: falling > digging > bump direction change

                if (!ground) begin
                    // ground lost, start falling, direction unchanged
                    next_mode = FALLING;
                end else if (dig && stable_ground) begin
                    // start digging if dig asserted on stable ground
                    next_mode = DIGGING;
                end else if (stable_ground && (bump_left || bump_right)) begin
                    // bumps affect direction only if stable_ground and walking
                    if (bump_left && bump_right) begin
                        // both bumps toggle direction
                        next_dir = ~dir;
                    end else if (bump_left) begin
                        // bump on left means walk right
                        next_dir = 1'b1;
                    end else if (bump_right) begin
                        // bump on right means walk left
                        next_dir = 1'b0;
                    end
                    next_mode = WALKING;
                end else begin
                    // no change
                    next_mode = WALKING;
                    next_dir  = dir;
                end
            end

            FALLING: begin
                // stay falling until ground returns
                if (ground) begin
                    next_mode = WALKING;
                end else begin
                    next_mode = FALLING;
                end
                // direction remains unchanged during falling
                next_dir = dir;
            end

            DIGGING: begin
                // stay digging if ground present, else fall
                if (!ground) begin
                    next_mode = FALLING;
                end else begin
                    next_mode = DIGGING;
                end
                // direction unchanged while digging
                next_dir = dir;
            end

            default: begin
                // safe fallback
                next_mode = WALKING;
                next_dir  = 1'b0;
            end
        endcase
    end

    // Moore outputs based on current state and direction
    assign walk_left  = (mode == WALKING) && (dir == 1'b0);
    assign walk_right = (mode == WALKING) && (dir == 1'b1);
    assign aaah       = (mode == FALLING);
    assign digging    = (mode == DIGGING);

endmodule