module TopModule (
    input  logic clk,
    input  logic areset,       // asynchronous posedge reset
    input  logic bump_left,
    input  logic bump_right,
    input  logic ground,
    input  logic dig,
    output logic walk_left,
    output logic walk_right,
    output logic aaah,
    output logic digging
);

    typedef enum logic [1:0] {
        MODE_WALK  = 2'd0,
        MODE_DIG   = 2'd1,
        MODE_FALL  = 2'd2,
        MODE_SPLAT = 2'd3
    } mode_t;

    // State registers
    mode_t mode;
    logic direction;      // 0=left, 1=right
    logic [4:0] fall_timer;
    logic fall_too_long;

    // Functional next-state logic

    function mode_t next_mode_func (
        mode_t cur_mode,
        logic cur_direction,
        logic [4:0] cur_fall_timer,
        logic cur_fall_too_long,
        logic bump_left_i,
        logic bump_right_i,
        logic ground_i,
        logic dig_i
    );
        // Determine next mode given inputs and current state
        if (cur_mode == MODE_SPLAT) begin
            return MODE_SPLAT;
        end
        else if (cur_mode == MODE_FALL) begin
            if (ground_i) begin
                if (cur_fall_too_long)
                    return MODE_SPLAT;
                else
                    return MODE_WALK;
            end else
                return MODE_FALL;
        end
        else if (cur_mode == MODE_WALK) begin
            if (!ground_i)
                return MODE_FALL;
            else if (dig_i)
                return MODE_DIG;
            else
                return MODE_WALK;
        end
        else if (cur_mode == MODE_DIG) begin
            if (!ground_i)
                return MODE_FALL;
            else
                return MODE_DIG;
        end
        else
            return MODE_WALK; // fallback
    endfunction

    function logic next_direction_func (
        mode_t cur_mode,
        logic cur_direction,
        logic bump_left_i,
        logic bump_right_i,
        logic ground_i,
        logic dig_i
    );
        // Direction only changes when walking and bumped on ground; no changes falling or digging or splat
        if (cur_mode == MODE_WALK && ground_i) begin
            if (bump_left_i && bump_right_i)
                return ~cur_direction;
            else if (bump_left_i)
                return 1'b1;   // walk right
            else if (bump_right_i)
                return 1'b0;   // walk left
            else
                return cur_direction;
        end
        else begin
            // preserve direction in all other modes
            return cur_direction;
        end
    endfunction

    function logic [4:0] next_fall_timer_func (
        mode_t cur_mode,
        logic [4:0] cur_fall_timer,
        logic ground_i
    );
        if (cur_mode == MODE_FALL) begin
            if (ground_i)
                return 5'd0;
            else
                return cur_fall_timer + 5'd1;
        end else begin
            return 5'd0;
        end
    endfunction

    function logic next_fall_too_long_func (
        mode_t cur_mode,
        logic [4:0] cur_fall_timer,
        logic cur_fall_too_long,
        logic ground_i
    );
        if (cur_mode == MODE_FALL && !ground_i) begin
            // once fall too long is set it stays set in falling mode
            return cur_fall_too_long || (cur_fall_timer == 5'd20);
        end else if (cur_mode == MODE_FALL && ground_i) begin
            // reset on landing
            return 1'b0;
        end else begin
            return 1'b0;
        end
    endfunction

    // Sequential always_ff block with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0;   // walk left at reset
            fall_timer <= 5'd0;
            fall_too_long <= 1'b0;
        end else begin
            mode <= next_mode_func(mode, direction, fall_timer, fall_too_long,
                                   bump_left, bump_right, ground, dig);
            direction <= next_direction_func(mode, direction, bump_left, bump_right, ground, dig);
            fall_timer <= next_fall_timer_func(mode, fall_timer, ground);
            fall_too_long <= next_fall_too_long_func(mode, fall_timer, fall_too_long, ground);
        end
    end

    // Moore outputs decoded from current state
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule