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
        MODE_WALK  = 2'd0,
        MODE_DIG   = 2'd1,
        MODE_FALL  = 2'd2,
        MODE_SPLAT = 2'd3
    } mode_t;

    mode_t mode, next_mode;
    logic direction, next_direction; // 0=left, 1=right
    logic [4:0] fall_timer, next_fall_timer;

    // Asynchronous reset for registers
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0;  // walk left
            fall_timer <= 5'd0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state logic for mode
    function mode_t calc_next_mode(
        input mode_t curr_mode,
        input logic curr_direction,
        input logic [4:0] curr_fall_timer,
        input bump_left,
        input bump_right,
        input ground,
        input dig
    );
        begin
            case (curr_mode)
                MODE_SPLAT: calc_next_mode = MODE_SPLAT;

                MODE_FALL:
                    if (ground) begin
                        if (curr_fall_timer > 5'd20)
                            calc_next_mode = MODE_SPLAT;
                        else
                            calc_next_mode = MODE_WALK;
                    end else
                        calc_next_mode = MODE_FALL;

                MODE_WALK:
                    if (!ground)
                        calc_next_mode = MODE_FALL;
                    else if (dig)
                        calc_next_mode = MODE_DIG;
                    else
                        calc_next_mode = MODE_WALK;

                MODE_DIG:
                    if (!ground)
                        calc_next_mode = MODE_FALL;
                    else
                        calc_next_mode = MODE_DIG;

                default: calc_next_mode = MODE_WALK;
            endcase
        end
    endfunction

    // Next state logic for direction
    function logic calc_next_direction(
        input mode_t curr_mode,
        input logic curr_direction,
        input bump_left,
        input bump_right
    );
        begin
            if (curr_mode == MODE_WALK) begin
                // Switch direction on any bump in walk mode
                if (bump_left || bump_right) begin
                    // Both bump case or single bump always flips direction
                    calc_next_direction = ~curr_direction;
                end else begin
                    calc_next_direction = curr_direction;
                end
            end else begin
                // In other modes direction unchanged
                calc_next_direction = curr_direction;
            end
        end
    endfunction

    // Next state logic for fall_timer
    function [4:0] calc_next_fall_timer(
        input mode_t curr_mode,
        input [4:0] curr_fall_timer,
        input logic ground
    );
        begin
            if (curr_mode == MODE_FALL) begin
                if (ground)
                    calc_next_fall_timer = 5'd0;
                else if (curr_fall_timer < 5'd21)
                    calc_next_fall_timer = curr_fall_timer + 1'b1;
                else
                    calc_next_fall_timer = 5'd21;
            end else begin
                calc_next_fall_timer = 5'd0;
            end
        end
    endfunction

    // Compute next values
    always_comb begin
        next_mode = calc_next_mode(mode, direction, fall_timer, bump_left, bump_right, ground, dig);
        next_direction = calc_next_direction(mode, direction, bump_left, bump_right);
        next_fall_timer = calc_next_fall_timer(mode, fall_timer, ground);
    end

    // Moore outputs from registered state
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule