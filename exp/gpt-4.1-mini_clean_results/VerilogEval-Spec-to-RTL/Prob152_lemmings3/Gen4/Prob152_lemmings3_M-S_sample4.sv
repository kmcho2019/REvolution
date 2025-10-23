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

    // Activity states
    localparam 
        WALKING = 2'd0,
        FALLING = 2'd1,
        DIGGING = 2'd2;

    reg [1:0] state, next_state;
    reg direction, next_direction; // 0 = left, 1 = right

    // Next state and direction logic (combinational)
    always @(*) begin
        next_state = state;
        next_direction = direction;

        case(state)
            WALKING: begin
                if (!ground) begin
                    // Fall with same direction
                    next_state = FALLING;
                end else if (dig) begin
                    // Start digging only if on ground and walking
                    next_state = DIGGING;
                end else begin
                    // Switch direction if bumped on the side we're walking into
                    if ((direction == 0 && bump_left) || (direction == 1 && bump_right))
                        next_direction = ~direction;
                end
            end

            FALLING: begin
                // Stay falling while no ground
                if (ground) begin
                    // Land and resume walking same direction
                    next_state = WALKING;
                end
            end

            DIGGING: begin
                if (!ground) begin
                    // Stop digging and start falling same direction
                    next_state = FALLING;
                end
                // else keep digging
            end

            default: begin
                // Safety fallback
                next_state = WALKING;
                next_direction = 0;
            end
        endcase
    end

    // State and direction register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING;
            direction <= 0; // walk left on reset
        end else begin
            state <= next_state;
            direction <= next_direction;
        end
    end

    // Outputs (Moore outputs depend on state and direction)
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case(state)
            WALKING: begin
                if (direction == 0)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end
            FALLING: begin
                aaah = 1'b1;
            end
            DIGGING: begin
                digging = 1'b1;
                if (direction == 0)
                    walk_left = 1'b1;
                else
                    walk_right = 1'b1;
            end
            default: begin
                walk_left = 1'b1; // default safe output
            end
        endcase
    end

endmodule