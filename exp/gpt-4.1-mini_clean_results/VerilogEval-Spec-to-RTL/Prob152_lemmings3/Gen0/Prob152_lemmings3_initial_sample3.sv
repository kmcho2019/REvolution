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
    // State encoding
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam DIGGING    = 2'b10;
    localparam FALLING    = 2'b11;

    reg [1:0] state, next_state;
    reg walk_dir; // 0 = left, 1 = right; track walking direction to resume after fall

    // Async reset, state and walk_dir register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walk_dir <= 1'b0; // left
        end else begin
            state <= next_state;
            // Update walking direction when in WALK_LEFT or WALK_RIGHT
            if (next_state == WALK_LEFT)
                walk_dir <= 1'b0;
            else if (next_state == WALK_RIGHT)
                walk_dir <= 1'b1;
            // During FALLING and DIGGING walking direction remains unchanged
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left || bump_right) begin
                    // switch direction
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left || bump_right) begin
                    // switch direction
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            DIGGING: begin
                // While digging, bump and dig ignored
                // If ground disappears, start falling
                if (!ground) begin
                    next_state = FALLING;
                end else begin
                    next_state = DIGGING;
                end
            end

            FALLING: begin
                // While falling, bumps and dig ignored
                // When ground reappears, go back to walking with remembered walk_dir
                if (ground) begin
                    if (walk_dir == 1'b0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic: Moore outputs based on state
    always @(*) begin
        // default all outputs 0
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case(state)
            WALK_LEFT: begin
                walk_left = 1;
            end
            WALK_RIGHT: begin
                walk_right = 1;
            end
            DIGGING: begin
                digging = 1;
                if (!ground)
                    aaah = 1; // during transition to fall, but state still DIGGING when ground=0?
                // However per spec, once ground=0 while digging, Lemming falls and says "aaah!"
                // This is handled in next cycle, outputs follow state so no aaah while DIGGING and ground=1.
            end
            FALLING: begin
                aaah = 1;
            end
        endcase
    end

endmodule