module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);
    // State encoding
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING    = 2'b10;

    reg [1:0] state, next_state;
    reg ground_d;
    reg [1:0] prev_walk_dir; // stores WALK_LEFT or WALK_RIGHT before falling

    // Sequential logic: state and ground_d update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK_LEFT;
            ground_d   <= 1'b1; // Assume start on ground
            prev_walk_dir <= WALK_LEFT;
        end else begin
            state    <= next_state;
            ground_d <= ground;
            // Update prev_walk_dir only when walking (not falling)
            if (state != FALLING) begin
                prev_walk_dir <= next_state == FALLING ? prev_walk_dir : next_state;
            end
        end
    end

    // Combinational logic for next_state
    always @(*) begin
        // Detect falling start: ground was 1, now 0
        wire falling_start = (ground_d == 1'b1) && (ground == 1'b0);

        case (state)
            WALK_LEFT: begin
                if (falling_start) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (falling_start) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALLING: begin
                if (ground == 1'b1) begin
                    // Land: restore walking direction before fall
                    next_state = prev_walk_dir;
                end else begin
                    next_state = FALLING;
                end
            end

            default: next_state = WALK_LEFT; // Safe default
        endcase
    end

    // Outputs (Moore)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule