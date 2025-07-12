module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // One-hot encoding of states
    localparam WALKING  = 3'b001;
    localparam FALLING  = 3'b010;
    localparam DIGGING  = 3'b100;

    reg [2:0] state, next_state;
    reg dir, next_dir; // 0=left, 1=right

    reg prev_ground;

    // Update prev_ground only if ground changes to reduce toggling
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            prev_ground <= 1'b1; // Assume starts on ground
        end else if (ground != prev_ground) begin
            prev_ground <= ground;
        end
    end

    // State and direction update combined for timing and simplicity
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING;
            dir <= 1'b0; // walk left on reset
        end else begin
            state <= next_state;
            dir <= next_dir;
        end
    end

    // stable_ground means ground steady high
    wire stable_ground = (ground == 1'b1) && (prev_ground == 1'b1);

    // Bump detected during walking when stable ground
    wire bump_detect = stable_ground && (bump_left || bump_right);

    // Determine direction update only if bump detected in walking state
    // Direction toggling rule:
    // If bump_left and bump_right both high => toggle direction
    // else bump_left only => walk right (dir=1)
    // else bump_right only => walk left (dir=0)
    reg dir_changed;
    always @(*) begin
        dir_changed = 1'b0;
        next_dir = dir;

        if (state == WALKING && bump_detect) begin
            if (bump_left && bump_right) begin
                next_dir = ~dir;
            end else if (bump_left) begin
                next_dir = 1'b1;
            end else begin // bump_right only
                next_dir = 1'b0;
            end
            dir_changed = (next_dir != dir);
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            WALKING: begin
                // Priority fall > dig > bump direction
                if (ground == 1'b0) begin
                    next_state = FALLING;
                end else if (dig && stable_ground) begin
                    next_state = DIGGING;
                end else begin
                    // stay walking
                    next_state = WALKING;
                end
            end
            FALLING: begin
                if (ground == 1'b1) begin
                    next_state = WALKING;
                end else begin
                    next_state = FALLING;
                end
            end
            DIGGING: begin
                if (ground == 1'b0) begin
                    next_state = FALLING;
                end else begin
                    next_state = DIGGING;
                end
            end
            default: next_state = WALKING;
        endcase
    end

    // Outputs (Moore style)
    assign walk_left  = (state == WALKING) && (dir == 1'b0);
    assign walk_right = (state == WALKING) && (dir == 1'b1);
    assign aaah       = (state == FALLING);
    assign digging    = (state == DIGGING);

endmodule