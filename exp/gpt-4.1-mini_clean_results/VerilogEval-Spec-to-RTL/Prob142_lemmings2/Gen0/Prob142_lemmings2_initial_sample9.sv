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
    localparam WALK_LEFT  = 2'd0;
    localparam WALK_RIGHT = 2'd1;
    localparam FALLING    = 2'd2;

    reg [1:0] state, next_state;
    reg prev_walk_dir; // 0 = left, 1 = right; remembers direction before falling

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            prev_walk_dir <= 1'b0; // left
        end else begin
            state <= next_state;
            // Update prev_walk_dir only when walking (not falling)
            if (next_state == WALK_LEFT)
                prev_walk_dir <= 1'b0;
            else if (next_state == WALK_RIGHT)
                prev_walk_dir <= 1'b1;
            // Do not update prev_walk_dir if falling
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            WALK_LEFT: begin
                if (ground == 1'b0)
                    next_state = FALLING;
                else if (bump_left || bump_right) // any bump causes direction change
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (ground == 1'b0)
                    next_state = FALLING;
                else if (bump_left || bump_right) // any bump causes direction change
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            FALLING: begin
                if (ground == 1'b1) begin
                    // Return to previous walking direction before falling
                    if (prev_walk_dir == 1'b0)
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

    // Output logic (Moore machine)
    always @(*) begin
        walk_left  = (state == WALK_LEFT);
        walk_right = (state == WALK_RIGHT);
        aaah       = (state == FALLING);
    end

endmodule