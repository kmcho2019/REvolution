module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // Mode states
    localparam MODE_WALK = 2'd0;
    localparam MODE_FALL = 2'd1;
    localparam MODE_DIG  = 2'd2;
    localparam MODE_SPLAT = 2'd3;

    reg [1:0] mode, next_mode;
    reg direction, next_direction; // 0=left, 1=right

    reg [5:0] fall_counter, next_fall_counter;

    // Synchronous reset (on clk posedge), asynchronous reset asserted high
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= MODE_WALK;
            direction <= 1'b0; // start walking left
            fall_counter <= 6'd0;
        end else begin
            mode <= next_mode;
            direction <= next_direction;
            fall_counter <= next_fall_counter;
        end
    end

    // Combinational logic for next state, direction, fall counter
    always @(*) begin
        // Default assignments
        next_mode = mode;
        next_direction = direction;
        next_fall_counter = (mode == MODE_FALL) ? (fall_counter + 6'd1) : 6'd0;

        case (mode)
            MODE_WALK: begin
                // Highest priority fall
                if (ground == 1'b0) begin
                    next_mode = MODE_FALL;
                    // direction stays the same during fall
                end else if (dig == 1'b1) begin
                    // Can dig only when walking on ground
                    next_mode = MODE_DIG;
                    // direction unchanged
                end else begin
                    // Check bumps, switch direction if bumped
                    if (bump_left && bump_right) begin
                        // bump on both sides, switch direction
                        next_direction = ~direction;
                    end else if (bump_left) begin
                        // bumped on left, walk right
                        next_direction = 1'b1;
                    end else if (bump_right) begin
                        // bumped on right, walk left
                        next_direction = 1'b0;
                    end
                end
            end

            MODE_DIG: begin
                // Continue digging if ground present
                if (ground == 1'b0) begin
                    // No ground - fall
                    next_mode = MODE_FALL;
                    // direction preserved from dig state
                end
                // dig input ignored in dig mode
                // bumps ignored in dig mode
            end

            MODE_FALL: begin
                if (ground == 1'b1) begin
                    // Landed
                    if (fall_counter > 6'd20) begin
                        next_mode = MODE_SPLAT;
                        // direction does not matter in splattered
                    end else begin
                        next_mode = MODE_WALK;
                        // direction preserved through fall
                    end
                    // fall counter resets automatically next cycle
                end
                // bumps and dig ignored in fall mode
            end

            MODE_SPLAT: begin
                // Stay splattered forever until reset
                next_mode = MODE_SPLAT;
                // direction irrelevant
            end

            default: begin
                // Safety defaults
                next_mode = MODE_WALK;
                next_direction = 1'b0;
                next_fall_counter = 6'd0;
            end
        endcase
    end

    // Moore outputs from current mode and direction
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case (mode)
            MODE_WALK: begin
                if (direction == 1'b0)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end
            MODE_DIG: digging = 1'b1;
            MODE_FALL: aaah = 1'b1;
            MODE_SPLAT: begin
                // all outputs zero
            end
        endcase
    end

endmodule