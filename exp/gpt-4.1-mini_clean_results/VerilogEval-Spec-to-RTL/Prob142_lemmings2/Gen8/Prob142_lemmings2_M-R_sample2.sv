module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);
    // State encoding
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING    = 2'b10;

    reg [1:0] state, next_state;

    wire bump = bump_left | bump_right;
    wire both_bump = bump_left & bump_right;

    // Next state logic (Moore FSM)
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump) begin
                    if (both_bump)
                        next_state = WALK_RIGHT;
                    else if (bump_left)
                        next_state = WALK_RIGHT;
                    else // bump_right
                        next_state = WALK_LEFT; // Bumped right while walking left -> walk left still?
                        // Actually, bump_right while walking left: switch to walk left per problem => walking left. 
                        // But problem states bump_right means walk left, so already walking left, no change
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump) begin
                    if (both_bump)
                        next_state = WALK_LEFT;
                    else if (bump_left)
                        next_state = WALK_RIGHT;
                    else // bump_right
                        next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground)
                    next_state = (state == FALLING) ? state : state; // Actually must pick walking state before fall
                // We need to remember the direction before fall
                // So FALLING state alone can't encode direction
                // Therefore, augment state encoding to include direction during falling
                // Let's redefine states with direction bit embedded

                // But here with current encoding, losing direction info.
                // To fix, store direction separately in a reg 'direction'.

                // For now, stay in FALLING while ground=0
                // When ground=1, go to previous walking state, so next_state assigned externally
                next_state = state;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // To store direction during falling, define a reg 'direction' separately
    reg direction; // 0=left,1=right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            direction <= 1'b0; // left
        end else begin
            case (state)
                WALK_LEFT, WALK_RIGHT: begin
                    if (!ground) begin
                        state <= FALLING;
                        // direction unchanged
                    end else if (bump) begin
                        if (both_bump) begin
                            direction <= ~direction;
                            state <= ~direction ? WALK_LEFT : WALK_RIGHT; // After flip
                        end else if (bump_left) begin
                            direction <= 1'b1; // right
                            state <= WALK_RIGHT;
                        end else begin // bump_right
                            direction <= 1'b0; // left
                            state <= WALK_LEFT;
                        end
                    end else begin
                        direction <= direction;
                        state <= state;
                    end
                end
                FALLING: begin
                    if (ground) begin
                        // return to walking in the previous direction
                        state <= direction ? WALK_RIGHT : WALK_LEFT;
                    end else begin
                        state <= FALLING;
                    end
                    // direction unchanged during falling
                end
                default: begin
                    state <= WALK_LEFT;
                    direction <= 1'b0;
                end
            endcase
        end
    end

    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule