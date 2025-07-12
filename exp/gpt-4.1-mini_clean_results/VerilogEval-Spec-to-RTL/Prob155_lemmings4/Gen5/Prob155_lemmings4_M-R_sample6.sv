module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding
    typedef enum logic [1:0] {
        ST_WALK = 2'b00,
        ST_FALL = 2'b01,
        ST_DIG  = 2'b10,
        ST_SPLAT= 2'b11
    } state_t;

    state_t state, next_state;
    logic dir, next_dir;       // 0=left, 1=right
    logic [4:0] fall_count, next_fall_count; // saturating counter

    // Invert direction helper
    function logic invert_dir(input logic d);
        invert_dir = ~d;
    endfunction

    // Asynchronous reset and state register
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= ST_WALK;
            dir <= 1'b0;         // walk left after reset
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            dir <= next_dir;
            fall_count <= next_fall_count;
        end
    end

    // Next state logic
    always_comb begin
        // Defaults
        next_state = state;
        next_dir = dir;
        next_fall_count = fall_count;

        case (state)
            ST_WALK: begin
                if (!ground) begin
                    // fall start
                    next_state = ST_FALL;
                    next_fall_count = 5'd1;
                    // direction unchanged
                    next_dir = dir;
                end else if (dig) begin
                    // start digging
                    next_state = ST_DIG;
                    next_fall_count = 5'd0;
                    // direction unchanged
                    next_dir = dir;
                end else begin
                    // bumps to change direction
                    if (bump_left && bump_right) begin
                        next_dir = invert_dir(dir);
                    end else if (bump_left) begin
                        next_dir = 1'b1; // walk right
                    end else if (bump_right) begin
                        next_dir = 1'b0; // walk left
                    end
                    next_state = ST_WALK;
                    next_fall_count = 5'd0;
                end
            end

            ST_FALL: begin
                if (!ground) begin
                    // continue falling, saturate at 31
                    next_state = ST_FALL;
                    next_dir = dir;
                    next_fall_count = (fall_count < 5'd31) ? fall_count + 5'd1 : fall_count;
                end else begin
                    // landed
                    if (fall_count > 5'd20) begin
                        next_state = ST_SPLAT;
                        next_dir = dir; // direction is irrelevant, keep unchanged
                        next_fall_count = 5'd0;
                    end else begin
                        next_state = ST_WALK;
                        next_dir = dir;
                        next_fall_count = 5'd0;
                    end
                end
            end

            ST_DIG: begin
                if (!ground) begin
                    // fall start from digging
                    next_state = ST_FALL;
                    next_fall_count = 5'd1;
                    next_dir = dir;
                end else begin
                    // continue digging
                    next_state = ST_DIG;
                    next_dir = dir;
                    next_fall_count = 5'd0;
                end
            end

            ST_SPLAT: begin
                // remain splatted forever until reset
                next_state = ST_SPLAT;
                next_dir = dir;
                next_fall_count = 5'd0;
            end

            default: begin
                // fallback to reset state
                next_state = ST_WALK;
                next_dir = 1'b0;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Outputs: Moore style, combinational assigns
    assign walk_left = (state == ST_WALK) && (dir == 1'b0);
    assign walk_right = (state == ST_WALK) && (dir == 1'b1);
    assign aaah = (state == ST_FALL);
    assign digging = (state == ST_DIG);

endmodule