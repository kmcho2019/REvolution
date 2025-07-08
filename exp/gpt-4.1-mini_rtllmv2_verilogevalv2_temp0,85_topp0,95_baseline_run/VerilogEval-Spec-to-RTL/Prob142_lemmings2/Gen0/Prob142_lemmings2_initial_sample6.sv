module TopModule(
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
    reg prev_dir; // 0 for left, 1 for right; remembers direction before falling

    // Asynchronous reset + synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            prev_dir <= 1'b0; // left
        end else begin
            state <= next_state;
            // Update prev_dir when changing walking direction or resuming walking
            if (next_state == WALK_LEFT)
                prev_dir <= 1'b0;
            else if (next_state == WALK_RIGHT)
                prev_dir <= 1'b1;
            // no change to prev_dir when falling
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            WALK_LEFT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // Switch to walking right if bumped on either side
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // Switch to walking left if bumped on either side
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground == 1) begin
                    // Resume previous walking direction
                    next_state = prev_dir ? WALK_RIGHT : WALK_LEFT;
                end else begin
                    next_state = FALLING;
                end
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        walk_left  = (state == WALK_LEFT);
        walk_right = (state == WALK_RIGHT);
        aaah       = (state == FALLING);
    end

endmodule