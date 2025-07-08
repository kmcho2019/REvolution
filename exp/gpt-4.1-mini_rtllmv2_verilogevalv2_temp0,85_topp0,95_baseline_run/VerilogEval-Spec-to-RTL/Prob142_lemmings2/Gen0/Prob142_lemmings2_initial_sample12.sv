module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // State encoding
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING    = 2'b10;

    reg [1:0] state, next_state;
    reg [1:0] prev_walk_state; // To remember walking direction before falling

    // Async reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            prev_walk_state <= WALK_LEFT;
        end else begin
            state <= next_state;
            // Update previous walking state only when walking
            if (state == WALK_LEFT || state == WALK_RIGHT) begin
                prev_walk_state <= state;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            WALK_LEFT: begin
                if (ground == 1'b0) begin
                    next_state = FALLING;
                end else if (bump_left == 1'b1) begin
                    // bump_left or bump_left+bump_right -> switch to walk right
                    next_state = WALK_RIGHT;
                end else if (bump_right == 1'b1) begin
                    // bump_right only -> switch to walk left (already walking left, stays)
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    next_state = FALLING;
                end else if (bump_right == 1'b1) begin
                    // bump_right or bump_left+bump_right -> switch to walk left
                    next_state = WALK_LEFT;
                end else if (bump_left == 1'b1) begin
                    // bump_left only -> switch to walk right (already walking right, stays)
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground == 1'b1) begin
                    // Return to previous walking state
                    next_state = prev_walk_state;
                end else begin
                    next_state = FALLING;
                end
            end
            default: next_state = WALK_LEFT;
        endcase

        // Handle bump both sides at once:
        // If bump_left and bump_right both high, switch direction regardless
        // Only when walking, bump affects direction.
        if ((state == WALK_LEFT || state == WALK_RIGHT) && (bump_left == 1'b1 && bump_right == 1'b1)) begin
            if (state == WALK_LEFT)
                next_state = WALK_RIGHT;
            else if (state == WALK_RIGHT)
                next_state = WALK_LEFT;
        end
    end

    // Output logic (Moore)
    always @(*) begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        case(state)
            WALK_LEFT: begin
                walk_left = 1'b1;
            end
            WALK_RIGHT: begin
                walk_right = 1'b1;
            end
            FALLING: begin
                aaah = 1'b1;
            end
        endcase
    end

endmodule