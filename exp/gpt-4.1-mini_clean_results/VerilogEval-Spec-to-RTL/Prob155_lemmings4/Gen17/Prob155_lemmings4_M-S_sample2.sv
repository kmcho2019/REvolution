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

    // State encoding: [2]=direction (0=left,1=right), [1:0]=mode
    // mode: 00=WALK, 01=DIG, 10=FALL, 11=SPLAT
    typedef enum logic [1:0] {
        WALK = 2'd0,
        DIG  = 2'd1,
        FALL = 2'd2,
        SPLAT= 2'd3
    } mode_t;

    typedef logic [2:0] state_t; // {direction, mode}

    state_t state, next_state;
    logic [4:0] fall_timer, next_fall_timer;

    wire bump = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;
    wire [1:0] mode = state[1:0];
    wire direction = state[2];
    wire splat_condition = (fall_timer > 5'd20);

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= {1'b0, WALK};  // direction=0(left), mode=WALK
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    always_comb begin
        next_state = state;
        next_fall_timer = fall_timer;

        case (mode)
            SPLAT: begin
                // Stuck forever
                next_state = state;
                next_fall_timer = 5'd0;
            end
            FALL: begin
                if (ground) begin
                    if (splat_condition)
                        next_state = {direction, SPLAT};
                    else
                        next_state = {direction, WALK};
                    next_fall_timer = 5'd0;
                end else begin
                    next_state = state;
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1;
                end
            end
            WALK: begin
                if (!ground) begin
                    next_state = {direction, FALL};
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    next_state = {direction, DIG};
                    next_fall_timer = 5'd0;
                end else if (bump_both) begin
                    // flip direction
                    next_state = {!direction, WALK};
                    next_fall_timer = 5'd0;
                end else if (bump_left) begin
                    next_state = {1'b1, WALK}; // walk right
                    next_fall_timer = 5'd0;
                end else if (bump_right) begin
                    next_state = {1'b0, WALK}; // walk left
                    next_fall_timer = 5'd0;
                end else begin
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end
            DIG: begin
                if (!ground) begin
                    next_state = {direction, FALL};
                    next_fall_timer = 5'd1;
                end else begin
                    next_state = state;
                    next_fall_timer = 5'd0;
                end
            end
            default: begin
                next_state = {1'b0, WALK};
                next_fall_timer = 5'd0;
            end
        endcase
    end

    assign walk_left  = (mode == WALK) && (direction == 1'b0);
    assign walk_right = (mode == WALK) && (direction == 1'b1);
    assign aaah       = (mode == FALL);
    assign digging    = (mode == DIG);

endmodule