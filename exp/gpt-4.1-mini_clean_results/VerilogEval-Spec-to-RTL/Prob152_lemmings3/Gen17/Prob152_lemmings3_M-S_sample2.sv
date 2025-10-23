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
    // State encoding: 3 bits
    // bit [0]: direction (0=left,1=right)
    // bits [2:1]:
    // 00 - walk
    // 01 - fall
    // 10 - dig
    localparam WALK_LEFT  = 3'b000;
    localparam WALK_RIGHT = 3'b001;
    localparam FALL_LEFT  = 3'b010;
    localparam FALL_RIGHT = 3'b011;
    localparam DIG_LEFT   = 3'b100;
    localparam DIG_RIGHT  = 3'b101;

    reg [2:0] state, next_state;

    // Next-state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            WALK_LEFT, WALK_RIGHT: begin
                if (!ground) begin
                    // fall preserves direction
                    next_state = state[0] ? FALL_RIGHT : FALL_LEFT;
                end else if (dig) begin
                    next_state = state[0] ? DIG_RIGHT : DIG_LEFT;
                end else begin
                    // bump changes direction
                    if (bump_left || bump_right) begin
                        // change direction when bumped on either side
                        if (bump_left && bump_right) begin
                            next_state = state[0] ? WALK_LEFT : WALK_RIGHT;
                        end else if (bump_left) begin
                            next_state = WALK_RIGHT;
                        end else /* bump_right */ begin
                            next_state = WALK_LEFT;
                        end
                    end
                end
            end
            DIG_LEFT, DIG_RIGHT: begin
                if (!ground) begin
                    // start falling in same direction
                    next_state = state[0] ? FALL_RIGHT : FALL_LEFT;
                end
            end
            FALL_LEFT, FALL_RIGHT: begin
                if (ground) begin
                    // stop falling, resume walking same direction
                    next_state = state[0] ? WALK_RIGHT : WALK_LEFT;
                end
            end
            default: next_state = WALK_LEFT; // safe reset
        endcase
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Output logic (Moore)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule