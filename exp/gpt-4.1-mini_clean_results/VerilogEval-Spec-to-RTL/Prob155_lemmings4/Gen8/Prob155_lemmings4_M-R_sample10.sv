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

    typedef enum logic [1:0] {
        MODE_WALK  = 2'd0,
        MODE_DIG   = 2'd1,
        MODE_FALL  = 2'd2,
        MODE_SPLAT = 2'd3
    } mode_t;

    // State registers
    mode_t mode_reg, mode_next;
    logic direction_reg, direction_next; // 0=left, 1=right
    logic [4:0] fall_timer_reg, fall_timer_next;

    // Asynchronous reset on mode and direction, fall_timer resets synchronously
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            mode_reg <= MODE_WALK;
            direction_reg <= 1'b0; // walk left
            fall_timer_reg <= 5'd0;
        end else begin
            mode_reg <= mode_next;
            direction_reg <= direction_next;
            fall_timer_reg <= fall_timer_next;
        end
    end

    // Function to compute next mode based on current inputs and state
    function automatic mode_t get_next_mode(
        mode_t mode,
        logic ground,
        logic dig,
        logic bump_left,
        logic bump_right,
        logic [4:0] fall_timer
    );
        case (mode)
            MODE_SPLAT: get_next_mode = MODE_SPLAT;
            MODE_FALL:
                if (ground) begin
                    if (fall_timer > 5'd20)
                        get_next_mode = MODE_SPLAT;
                    else
                        get_next_mode = MODE_WALK;
                end else
                    get_next_mode = MODE_FALL;
            MODE_WALK:
                if (!ground)
                    get_next_mode = MODE_FALL;
                else if (dig)
                    get_next_mode = MODE_DIG;
                else
                    get_next_mode = MODE_WALK;
            MODE_DIG:
                if (!ground)
                    get_next_mode = MODE_FALL;
                else
                    get_next_mode = MODE_DIG;
            default: get_next_mode = MODE_WALK;
        endcase
    endfunction

    // Function to compute next direction based on current state and bump inputs
    function automatic logic get_next_direction(
        mode_t mode,
        logic direction,
        logic bump_left,
        logic bump_right
    );
        if (mode == MODE_WALK) begin
            if (bump_left && bump_right)
                get_next_direction = ~direction;
            else if (bump_left)
                get_next_direction = 1'b1; // right
            else if (bump_right)
                get_next_direction = 1'b0; // left
            else
                get_next_direction = direction;
        end else
            get_next_direction = direction; // no change while falling, digging, splat
    endfunction

    // Compute next fall_timer value
    function automatic logic [4:0] get_next_fall_timer(
        mode_t mode,
        logic [4:0] fall_timer
    );
        if (mode == MODE_FALL) begin
            if (fall_timer < 5'd31)
                get_next_fall_timer = fall_timer + 1;
            else
                get_next_fall_timer = 5'd31;
        end else
            get_next_fall_timer = 5'd0;
    endfunction

    // Combinational logic for next states
    always_comb begin
        mode_next = get_next_mode(mode_reg, ground, dig, bump_left, bump_right, fall_timer_reg);
        direction_next = get_next_direction(mode_reg, direction_reg, bump_left, bump_right);
        fall_timer_next = get_next_fall_timer(mode_next, fall_timer_reg);

        // If we just started falling this cycle (ground=0 and previously on ground), set fall_timer to 1
        if (mode_reg != MODE_FALL && mode_next == MODE_FALL)
            fall_timer_next = 5'd1;
    end

    // Moore output logic
    assign walk_left  = (mode_reg == MODE_WALK) && (direction_reg == 1'b0);
    assign walk_right = (mode_reg == MODE_WALK) && (direction_reg == 1'b1);
    assign aaah       = (mode_reg == MODE_FALL);
    assign digging    = (mode_reg == MODE_DIG);

endmodule