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
    reg prev_dir; // 0=left, 1=right, remembers walking direction before falling

    // Next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALLING;
                else if (bump_left || bump_right) begin
                    // On bump, switch to walk right
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALLING;
                else if (bump_left || bump_right) begin
                    // On bump, switch to walk left
                    next_state = WALK_LEFT;
                end
            end
            FALLING: begin
                if (ground) begin
                    // Resume walking in previous direction
                    next_state = prev_dir ? WALK_RIGHT : WALK_LEFT;
                end
            end
        endcase
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state    <= WALK_LEFT;
            prev_dir <= 1'b0; // walking left
        end else begin
            // Update prev_dir when entering FALLING state
            if (state != FALLING && next_state == FALLING) begin
                prev_dir <= (state == WALK_RIGHT);
            end
            state <= next_state;
        end
    end

    // Outputs based on current state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule