module TopModule (
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
    // Modes
    localparam WALK = 2'd0, DIG = 2'd1, FALL = 2'd2, SPLAT = 2'd3;

    reg [1:0] mode, direction;
    reg direction_bit;
    reg [1:0] next_mode;
    reg next_direction_bit;
    reg [4:0] fall_timer, next_fall_timer;

    // State registers with async posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= WALK;
            direction_bit <= 1'b0; // walk left
            fall_timer <= 5'd0;
        end else begin
            mode <= next_mode;
            direction_bit <= next_direction_bit;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state logic with priority:
    // fall > dig > bump/change dir (if walking on ground)
    always @(*) begin
        next_mode = mode;
        next_direction_bit = direction_bit;
        next_fall_timer = (mode == FALL) ? ((fall_timer < 5'd31) ? fall_timer + 1 : 5'd31) : 5'd0;

        case (mode)
            SPLAT: begin
                // Stay splatted forever
                next_mode = SPLAT;
            end
            FALL: begin
                if (ground) begin
                    next_mode = (fall_timer > 5'd20) ? SPLAT : WALK;
                    next_fall_timer = 5'd0;
                end
            end
            WALK: begin
                if (!ground) begin
                    next_mode = FALL;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    next_mode = DIG;
                end else if (bump_left || bump_right) begin
                    // If bump both or either, flip or set direction accordingly
                    // Flip direction if bumped on both sides simultaneously
                    next_direction_bit = (bump_left && bump_right) ? ~direction_bit :
                                         bump_left ? 1'b1 : 1'b0;
                end
            end
            DIG: begin
                if (!ground) begin
                    next_mode = FALL;
                    next_fall_timer = 5'd1;
                end
            end
        endcase
    end

    // Outputs (Moore)
    assign walk_left  = (mode == WALK) && (direction_bit == 1'b0);
    assign walk_right = (mode == WALK) && (direction_bit == 1'b1);
    assign aaah       = (mode == FALL);
    assign digging    = (mode == DIG);

endmodule