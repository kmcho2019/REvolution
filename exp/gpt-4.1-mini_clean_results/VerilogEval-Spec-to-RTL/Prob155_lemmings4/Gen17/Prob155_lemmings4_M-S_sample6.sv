module TopModule (
    input  clk,
    input  areset,       // async posedge reset
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
    localparam WALK  = 2'b00;
    localparam DIG   = 2'b01;
    localparam FALL  = 2'b10;
    localparam SPLAT = 2'b11;

    reg [1:0] state, next_state;
    reg direction, next_direction;  // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer;

    // Conditions
    wire bump = bump_left | bump_right;
    wire hit_ground = ground;
    wire splat_condition = (fall_timer > 5'd20);

    // Asynchronous reset and sequential update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // walk left initially
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state logic
    always @* begin
        next_state = state;
        next_direction = direction;
        next_fall_timer = fall_timer;

        case (state)
            SPLAT: begin
                // Forever splatted
                next_state = SPLAT;
                next_fall_timer = 5'd0;
                // direction unchanged
            end

            FALL: begin
                if (hit_ground) begin
                    if (splat_condition)
                        next_state = SPLAT;
                    else
                        next_state = WALK;
                    next_fall_timer = 5'd0;
                    // direction preserved
                end else begin
                    next_state = FALL;
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
                end
                // direction unchanged
            end

            DIG: begin
                if (!hit_ground) begin
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    // direction unchanged
                end else begin
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    // direction unchanged
                end
            end

            WALK: begin
                if (!hit_ground) begin
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    // direction unchanged
                end else if (dig) begin
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    // direction unchanged
                end else begin
                    // Switch direction if bumped on either side
                    next_state = WALK;
                    next_fall_timer = 5'd0;
                    if (bump)
                        next_direction = ~direction;
                end
            end

            default: begin
                next_state = WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule