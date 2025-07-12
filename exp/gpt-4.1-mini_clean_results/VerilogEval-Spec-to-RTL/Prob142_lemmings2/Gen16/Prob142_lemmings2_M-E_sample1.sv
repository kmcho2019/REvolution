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

    // State one-hot encoding
    // Only one state bit is active at a time
    localparam STATE_WALK_LEFT  = 3'b100;
    localparam STATE_WALK_RIGHT = 3'b010;
    localparam STATE_FALL       = 3'b001;

    reg [2:0] state, next_state;
    reg direction; // 0=left, 1=right; remembers direction while falling

    // Bump detected when walking (either left or right)
    wire bump = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    always @(*) begin
        // Default next state to current
        next_state = state;

        case (state)
            STATE_WALK_LEFT: begin
                if (ground == 1'b0) begin
                    // Start falling, keep direction left
                    next_state = STATE_FALL;
                end else if (bump) begin
                    // Any bump flips direction to right
                    next_state = STATE_WALK_RIGHT;
                end else begin
                    next_state = STATE_WALK_LEFT;
                end
            end

            STATE_WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    // Start falling, keep direction right
                    next_state = STATE_FALL;
                end else if (bump) begin
                    // Any bump flips direction to left
                    next_state = STATE_WALK_LEFT;
                end else begin
                    next_state = STATE_WALK_RIGHT;
                end
            end

            STATE_FALL: begin
                if (ground == 1'b1) begin
                    // Ground back, resume walking in saved direction
                    next_state = direction ? STATE_WALK_RIGHT : STATE_WALK_LEFT;
                end else begin
                    next_state = STATE_FALL;
                end
            end

            default: begin
                next_state = STATE_WALK_LEFT; // Safety default
            end
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset to walking left
            state <= STATE_WALK_LEFT;
            direction <= 1'b0; // left
        end else begin
            state <= next_state;
            // Update direction only when walking and bumped
            if ((state == STATE_WALK_LEFT || state == STATE_WALK_RIGHT) && bump) begin
                direction <= (state == STATE_WALK_LEFT) ? 1'b1 : 1'b0; 
                // walking left + bump => direction right
                // walking right + bump => direction left
            end
            // When falling, direction holds
            // On ground loss, direction saved from current walking direction implicitly
        end
    end

    // Outputs from state bits
    assign aaah       = (state == STATE_FALL);
    assign walk_left  = (state == STATE_WALK_LEFT);
    assign walk_right = (state == STATE_WALK_RIGHT);

endmodule