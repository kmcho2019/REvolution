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
    localparam WALKING = 2'd0;
    localparam FALLING = 2'd1;
    localparam DIGGING = 2'd2;

    reg [1:0] mode, next_mode;
    reg       direction, next_direction; // 0=left, 1=right

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            mode <= WALKING;
            direction <= 1'b0; // left
        end else begin
            mode <= next_mode;
            direction <= next_direction;
        end
    end

    // Next state logic
    always @(*) begin
        // Defaults to current values
        next_mode = mode;
        next_direction = direction;

        case (mode)
            WALKING: begin
                if (!ground) begin
                    // Fall immediately if no ground
                    next_mode = FALLING;
                end else if (dig) begin
                    // Start digging if commanded and on ground
                    next_mode = DIGGING;
                end else if (bump_left || bump_right) begin
                    // Switch direction on bump while walking on ground
                    next_direction = ~direction;
                end
            end

            FALLING: begin
                if (ground) begin
                    // Stop falling and resume walking in same direction
                    next_mode = WALKING;
                end
                // else remain falling, bumps ignored
            end

            DIGGING: begin
                if (!ground) begin
                    // If ground disappears while digging, start falling
                    next_mode = FALLING;
                end
                // else remain digging, bumps ignored
            end

            default: begin
                // Should not occur, default to walking left
                next_mode = WALKING;
                next_direction = 1'b0;
            end
        endcase
    end

    // Outputs depend only on current state (Moore)
    assign walk_left  = (mode == WALKING) && (direction == 1'b0);
    assign walk_right = (mode == WALKING) && (direction == 1'b1);
    assign aaah       = (mode == FALLING);
    assign digging    = (mode == DIGGING);

endmodule