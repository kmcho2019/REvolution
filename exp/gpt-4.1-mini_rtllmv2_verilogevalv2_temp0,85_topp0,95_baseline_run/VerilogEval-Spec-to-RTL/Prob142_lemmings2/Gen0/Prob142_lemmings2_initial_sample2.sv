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
    localparam WALK_LEFT  = 2'd0;
    localparam WALK_RIGHT = 2'd1;
    localparam FALLING    = 2'd2;

    reg [1:0] state, next_state;
    reg [1:0] last_walk_state; // to remember walking direction before falling

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            last_walk_state <= WALK_LEFT;
        end else begin
            state <= next_state;
            // update last_walk_state only if not falling
            if (next_state != FALLING)
                last_walk_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // switch direction when bumped on left or right or both
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end
            end
            FALLING: begin
                if (ground) begin
                    // return to last walking direction
                    next_state = last_walk_state;
                end
                // bump inputs ignored while falling
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic (Moore outputs)
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;

        case(state)
            WALK_LEFT:  walk_left = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING:    aaah = 1'b1;
        endcase
    end

endmodule