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
    reg       last_dir; // 0=left,1=right, remembers direction before falling

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALLING;
                else if (bump_left || bump_right) 
                    next_state = WALK_RIGHT;
            end
            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALLING;
                else if (bump_left || bump_right) 
                    next_state = WALK_LEFT;
            end
            FALLING: begin
                if (ground) begin
                    // Return to last walking direction
                    next_state = last_dir ? WALK_RIGHT : WALK_LEFT;
                end
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Sequential state update and last_dir register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state    <= WALK_LEFT;
            last_dir <= 1'b0;
        end else begin
            // Update last_dir only when walking (not falling)
            if (state == WALK_LEFT)
                last_dir <= 1'b0;
            else if (state == WALK_RIGHT)
                last_dir <= 1'b1;

            state <= next_state;
        end
    end

    // Output logic: Moore outputs depend only on state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule