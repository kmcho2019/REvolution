module TopModule (
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
    reg       last_direction; // 0 = left, 1 = right; used only in FALLING state

    // Next state logic combinational
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Start falling, remember walking left
                    next_state     = FALLING;
                    // last_direction will be saved in sequential logic
                end else begin
                    // On ground, process bumps
                    if (bump_left && bump_right)
                        next_state = WALK_RIGHT;  // flip direction from left to right
                    else if (bump_left)
                        next_state = WALK_RIGHT;  // bump left => walk right
                    else if (bump_right)
                        next_state = WALK_LEFT;   // bump right => walk left (already left)
                    else
                        next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    // Start falling, remember walking right
                    next_state = FALLING;
                end else begin
                    // On ground, process bumps
                    if (bump_left && bump_right)
                        next_state = WALK_LEFT;  // flip direction from right to left
                    else if (bump_left)
                        next_state = WALK_RIGHT; // bump left => walk right (already right)
                    else if (bump_right)
                        next_state = WALK_LEFT;  // bump right => walk left
                    else
                        next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    // Return to walking state stored in last_direction
                    next_state = last_direction ? WALK_RIGHT : WALK_LEFT;
                end else begin
                    // Remain falling
                    next_state = FALLING;
                end
                // bumps ignored in falling
            end
            default: begin
                // Safety fallback (should not happen)
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Sequential state register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state          <= WALK_LEFT;
            last_direction <= 1'b0; // left
        end else begin
            if (state != FALLING && next_state == FALLING) begin
                // Save walking direction before falling
                last_direction <= (state == WALK_RIGHT) ? 1'b1 : 1'b0;
            end
            state <= next_state;
        end
    end

    // Output logic (Moore FSM)
    assign aaah       = (state == FALLING);
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule