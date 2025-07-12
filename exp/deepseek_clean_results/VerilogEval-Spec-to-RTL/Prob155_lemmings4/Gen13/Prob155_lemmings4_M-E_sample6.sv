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

    // Primary states
    localparam WALK = 2'b00;
    localparam FALL = 2'b01;
    localparam DIG  = 2'b10;
    localparam SPLAT = 2'b11;

    // Direction states
    localparam LEFT = 1'b0;
    localparam RIGHT = 1'b1;

    reg [1:0] primary_state, next_primary;
    reg direction, next_direction;
    reg last_direction;  // Persists through falls/digs
    reg [4:0] fall_counter;

    // Next state logic
    always @(*) begin
        // Defaults
        next_primary = primary_state;
        next_direction = direction;

        case (primary_state)
            WALK: begin
                if (~ground) begin
                    next_primary = FALL;
                end else if (dig) begin
                    next_primary = DIG;
                end else begin
                    // Handle bumps only when walking on ground
                    if (bump_left && ~bump_right) begin
                        next_direction = RIGHT;
                    end else if (bump_right && ~bump_left) begin
                        next_direction = LEFT;
                    end else if (bump_left && bump_right) begin
                        // Switch direction if both bumps
                        next_direction = ~direction;
                    end
                end
            end

            FALL: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_primary = SPLAT;
                    end else begin
                        next_primary = WALK;
                        next_direction = last_direction;
                    end
                end
            end

            DIG: begin
                if (~ground) begin
                    next_primary = FALL;
                end
            end

            SPLAT: begin
                // Stay in splat forever
                next_primary = SPLAT;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            primary_state <= WALK;
            direction <= LEFT;
            last_direction <= LEFT;
            fall_counter <= 0;
        end else begin
            primary_state <= next_primary;
            direction <= next_direction;

            // Update last_direction when walking
            if (primary_state == WALK) begin
                last_direction <= direction;
            end

            // Fall counter logic
            if (primary_state == FALL && ~ground) begin
                fall_counter <= fall_counter + 1;
            end else if (primary_state != FALL) begin
                fall_counter <= 0;
            end
        end
    end

    // Output logic
    assign walk_left = (primary_state == WALK) && (direction == LEFT);
    assign walk_right = (primary_state == WALK) && (direction == RIGHT);
    assign aaah = (primary_state == FALL);
    assign digging = (primary_state == DIG);

endmodule