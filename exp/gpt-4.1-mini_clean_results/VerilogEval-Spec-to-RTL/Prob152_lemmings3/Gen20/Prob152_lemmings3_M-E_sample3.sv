module TopModule(
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

    // Mode encoding
    localparam MODE_WALK = 2'b00;
    localparam MODE_FALL = 2'b01;
    localparam MODE_DIG  = 2'b10;

    reg direction;      // 0=left, 1=right
    reg [1:0] mode;

    reg next_direction;
    reg [1:0] next_mode;

    always @(*) begin
        // Default next values are current state
        next_direction = direction;
        next_mode = mode;

        // Priority:
        // 1) If no ground, FALL and stop digging
        if (!ground) begin
            next_mode = MODE_FALL;
            // direction unchanged when falling
            // digging cleared implicitly by mode change
        end else if (mode == MODE_FALL && ground) begin
            // Ground returns while falling: resume walking same direction
            next_mode = MODE_WALK;
            // direction unchanged
        end else if (mode == MODE_WALK) begin
            // Walking on ground, not digging
            if (dig) begin
                // Start digging
                next_mode = MODE_DIG;
                // direction unchanged
            end else if (bump_left || bump_right) begin
                // On bump, switch direction accordingly
                // Both bumps or either cause direction switch
                if (bump_left && bump_right) begin
                    next_direction = ~direction;
                end else if (bump_left) begin
                    next_direction = 1'b1; // walk right
                end else begin // bump_right only
                    next_direction = 1'b0; // walk left
                end
                // mode stays walk
                next_mode = MODE_WALK;
            end else begin
                // keep walking same direction and mode
                next_direction = direction;
                next_mode = MODE_WALK;
            end
        end else if (mode == MODE_DIG) begin
            // Digging mode
            if (!ground) begin
                // ground lost during digging -> fall, stop digging
                next_mode = MODE_FALL;
                // direction unchanged
            end else begin
                // continue digging
                next_mode = MODE_DIG;
                // direction unchanged
            end
        end else begin
            // Default fallback: stay same state
            next_mode = mode;
            next_direction = direction;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0;    // walk left initial
            mode <= MODE_WALK;
        end else begin
            direction <= next_direction;
            mode <= next_mode;
        end
    end

    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule