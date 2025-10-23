module TopModule (
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

    // One-hot state encoding
    parameter S_WALK_LEFT  = 5'b00001;
    parameter S_WALK_RIGHT = 5'b00010;
    parameter S_FALL       = 5'b00100;
    parameter S_DIG        = 5'b01000;
    parameter S_SPLAT      = 5'b10000;

    reg [4:0] state, next_state;
    reg [4:0] fall_counter;
    reg prev_walk_left;  // Track previous walking direction

    // State transition logic (combinational)
    assign next_state = 
        (state == S_WALK_LEFT)  ? (
            (~ground)            ? S_FALL :
            (dig)               ? S_DIG :
            (bump_left)         ? S_WALK_RIGHT :
                                   S_WALK_LEFT
        ) :
        (state == S_WALK_RIGHT) ? (
            (~ground)            ? S_FALL :
            (dig)               ? S_DIG :
            (bump_right)        ? S_WALK_LEFT :
                                   S_WALK_RIGHT
        ) :
        (state == S_FALL)       ? (
            (ground) ? (
                (fall_counter >= 20) ? S_SPLAT :
                (prev_walk_left)    ? S_WALK_LEFT :
                                       S_WALK_RIGHT
            ) : S_FALL
        ) :
        (state == S_DIG)        ? (
            (~ground) ? S_FALL : S_DIG
        ) :
        (state == S_SPLAT)      ? S_SPLAT :
                                   S_WALK_LEFT;  // default

    // State register and fall counter (sequential)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= S_WALK_LEFT;
            fall_counter <= 0;
            prev_walk_left <= 1;
        end else begin
            state <= next_state;
            
            // Update fall counter and previous direction
            if (state == S_FALL) begin
                if (ground) begin
                    fall_counter <= 0;
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end else begin
                fall_counter <= 0;
                // Remember walking direction when not falling
                if (state == S_WALK_LEFT) prev_walk_left <= 1;
                if (state == S_WALK_RIGHT) prev_walk_left <= 0;
            end
        end
    end

    // Output logic (combinational)
    assign walk_left = (state == S_WALK_LEFT);
    assign walk_right = (state == S_WALK_RIGHT);
    assign aaah = (state == S_FALL);
    assign digging = (state == S_DIG);

endmodule