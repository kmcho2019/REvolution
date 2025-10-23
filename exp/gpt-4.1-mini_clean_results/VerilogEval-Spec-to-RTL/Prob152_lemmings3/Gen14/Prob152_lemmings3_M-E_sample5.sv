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

    // State encoding
    localparam WALK_LEFT  = 3'b000;
    localparam WALK_RIGHT = 3'b001;
    localparam DIG_LEFT   = 3'b010;
    localparam DIG_RIGHT  = 3'b011;
    localparam FALL_LEFT  = 3'b100;
    localparam FALL_RIGHT = 3'b101;

    reg [2:0] state, next_state;

    // Determine next state
    always @(*) begin
        next_state = state;
        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Fall in current direction
                    next_state = FALL_LEFT;
                end else if (dig) begin
                    // Start digging
                    next_state = DIG_LEFT;
                end else if (bump_left || bump_right) begin
                    // Switch direction on bump
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else if (dig) begin
                    next_state = DIG_RIGHT;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end
            end
            DIG_LEFT: begin
                if (!ground) begin
                    // Fall after digging
                    next_state = FALL_LEFT;
                end
                // else keep digging
            end
            DIG_RIGHT: begin
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end
                // else keep digging
            end
            FALL_LEFT: begin
                if (ground) begin
                    // Stop falling, resume walk left
                    next_state = WALK_LEFT;
                end
                // else keep falling
            end
            FALL_RIGHT: begin
                if (ground) begin
                    next_state = WALK_RIGHT;
                end
                // else keep falling
            end
            default: begin
                // Undefined state safety fallback
                next_state = WALK_LEFT;
            end
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Outputs: based on current state (Moore outputs)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule