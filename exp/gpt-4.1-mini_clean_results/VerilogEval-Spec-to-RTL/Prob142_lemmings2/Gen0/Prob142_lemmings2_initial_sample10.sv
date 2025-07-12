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
    reg prev_ground;
    reg walk_dir_before_fall; // 0 for left, 1 for right

    // Synchronous state register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walk_dir_before_fall <= 1'b0; // left
            prev_ground <= 1'b1; // assume starting on ground
        end else begin
            state <= next_state;
            // Store walking direction before falling
            if (state != FALLING && ground == 0)
                walk_dir_before_fall <= (state == WALK_RIGHT);
            prev_ground <= ground;
        end
    end

    // Next state logic
    always @* begin
        case (state)
            WALK_LEFT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // Switch direction on bump
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // Switch direction on bump
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALLING: begin
                // Wait for ground to return
                if (ground == 1) begin
                    // Resume previous walking direction
                    next_state = walk_dir_before_fall ? WALK_RIGHT : WALK_LEFT;
                end else begin
                    next_state = FALLING;
                end
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic (Moore)
    always @* begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        case (state)
            WALK_LEFT:  walk_left  = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING:    aaah       = 1'b1;
        endcase
    end

endmodule