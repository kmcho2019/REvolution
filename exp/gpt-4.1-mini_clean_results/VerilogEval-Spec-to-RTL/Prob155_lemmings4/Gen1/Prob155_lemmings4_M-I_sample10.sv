module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding: 2-bit state to minimize FSM states
    typedef enum logic [1:0] {
        WALK = 2'd0,
        FALL = 2'd1,
        DIG  = 2'd2,
        SPLAT= 2'd3
    } state_t;

    state_t state, next_state;

    // Direction bit: 0 = left, 1 = right
    reg dir, next_dir;

    // Fall timer: 5 bits to count fall duration
    reg [4:0] fall_count, next_fall_count;

    // Asynchronous posedge reset with clk
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 1'b0;  // start walking left
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            dir <= next_dir;
            fall_count <= next_fall_count;
        end
    end

    // Next state and outputs logic
    always @(*) begin
        // Defaults: hold current values
        next_state = state;
        next_dir = dir;
        next_fall_count = fall_count;

        case(state)
            WALK: begin
                // Priority: fall > dig > bump
                if (ground == 1'b0) begin
                    // start falling, fall_count = 1
                    next_state = FALL;
                    next_fall_count = 5'd1;
                    // direction unchanged when falling
                    next_dir = dir;
                end else if (dig == 1'b1) begin
                    // start digging
                    next_state = DIG;
                    next_fall_count = 5'd0;
                    next_dir = dir;
                end else begin
                    // Handle bumps
                    // If bumped on left, walk right
                    // If bumped on right, walk left
                    // If both, reverse direction regardless
                    if (bump_left && bump_right) begin
                        next_dir = ~dir; // reverse direction
                    end else if (bump_left) begin
                        next_dir = 1'b1; // walk right
                    end else if (bump_right) begin
                        next_dir = 1'b0; // walk left
                    end
                    next_state = WALK;
                    next_fall_count = 5'd0;
                end
            end

            FALL: begin
                if (ground == 1'b0) begin
                    // continue falling, increment fall_count saturate at 31
                    next_state = FALL;
                    next_dir = dir;
                    if (fall_count < 5'd31)
                        next_fall_count = fall_count + 5'd1;
                    else
                        next_fall_count = fall_count;
                end else begin
                    // landed: check fall duration
                    if (fall_count > 5'd20) begin
                        next_state = SPLAT;
                        next_fall_count = 5'd0;
                        next_dir = dir; // irrelevant but kept
                    end else begin
                        next_state = WALK;
                        next_fall_count = 5'd0;
                        next_dir = dir;
                    end
                end
            end

            DIG: begin
                if (ground == 1'b0) begin
                    // start falling from dig state
                    next_state = FALL;
                    next_fall_count = 5'd1;
                    next_dir = dir;
                end else begin
                    // continue digging
                    next_state = DIG;
                    next_fall_count = 5'd0;
                    next_dir = dir;
                end
            end

            SPLAT: begin
                // forever splatted
                next_state = SPLAT;
                next_fall_count = 5'd0;
                next_dir = dir;
            end

            default: begin
                // safe recovery to walking left
                next_state = WALK;
                next_dir = 1'b0;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Moore outputs: derived from state and direction
    always @(*) begin
        // default outputs low
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case(state)
            WALK: begin
                if (dir == 1'b0)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end
            FALL: begin
                aaah = 1'b1;
            end
            DIG: begin
                digging = 1'b1;
            end
            SPLAT: begin
                // all outputs remain 0
            end
            default: begin
                // Should not occur, outputs zero
            end
        endcase
    end

endmodule