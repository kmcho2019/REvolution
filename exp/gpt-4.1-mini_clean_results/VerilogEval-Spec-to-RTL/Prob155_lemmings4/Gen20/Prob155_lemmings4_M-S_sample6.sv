module TopModule(
    input clk,
    input areset,       // asynchronous posedge reset
    input bump_left,
    input bump_right,
    input ground,
    input dig,
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
    reg direction, next_direction; // 0=left, 1=right
    reg [4:0] fall_timer, next_fall_timer;

    // Asynchronous reset and state registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state       <= WALK;
            direction   <= 1'b0; // walk left initially
            fall_timer  <= 5'd0;
        end else begin
            state       <= next_state;
            direction   <= next_direction;
            fall_timer  <= next_fall_timer;
        end
    end

    // Next state logic
    always @(*) begin
        // Defaults: hold current
        next_state = state;
        next_direction = direction;
        next_fall_timer = fall_timer;

        case(state)
            SPLAT: begin
                // Remain splatted forever
                next_state = SPLAT;
                // direction and timer irrelevant
                next_fall_timer = 5'd0;
            end
            FALL: begin
                if (ground) begin
                    if (fall_timer > 5'd20) begin
                        next_state = SPLAT;
                        next_fall_timer = 5'd0;
                    end else begin
                        next_state = WALK;
                        next_fall_timer = 5'd0;
                    end
                end else begin
                    next_state = FALL;
                    if (fall_timer < 5'd31)
                        next_fall_timer = fall_timer + 5'd1;
                    else
                        next_fall_timer = fall_timer;
                end
                // direction unchanged while falling
            end
            DIG: begin
                if (!ground) begin
                    // Ground gone: start falling
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    // direction unchanged while falling
                end else begin
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    // direction unchanged
                end
            end
            WALK: begin
                if (!ground) begin
                    // start falling
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    // direction unchanged while falling
                end else if (dig) begin
                    // start digging
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                end else begin
                    next_state = WALK;
                    next_fall_timer = 5'd0;
                    // bump logic: if bump both sides or one side, change direction
                    if (bump_left && bump_right)
                        next_direction = ~direction;
                    else if (bump_left)
                        next_direction = 1'b1; // walk right
                    else if (bump_right)
                        next_direction = 1'b0; // walk left
                    else
                        next_direction = direction;
                end
            end
            default: begin
                next_state = WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Outputs (Moore)
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule