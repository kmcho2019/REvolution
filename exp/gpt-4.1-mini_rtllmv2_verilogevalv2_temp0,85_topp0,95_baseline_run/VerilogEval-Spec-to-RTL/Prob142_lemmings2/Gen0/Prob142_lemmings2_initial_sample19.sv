module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // State encoding
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING    = 2'b10;

    reg [1:0] state, next_state;
    reg walk_dir; // 0 = left, 1 = right; remembers walking direction during falling

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walk_dir <= 0;
        end else begin
            state <= next_state;
            // Update walk_dir only when entering walking states
            if (next_state == WALK_LEFT)
                walk_dir <= 0;
            else if (next_state == WALK_RIGHT)
                walk_dir <= 1;
            // keep walk_dir unchanged when FALLING
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            WALK_LEFT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // switch direction
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // switch direction
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground == 1) begin
                    // resume previous walking direction stored in walk_dir
                    if (walk_dir == 0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end
            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        case(state)
            WALK_LEFT: begin
                walk_left  = 1'b1;
                walk_right = 1'b0;
                aaah       = 1'b0;
            end
            WALK_RIGHT: begin
                walk_left  = 1'b0;
                walk_right = 1'b1;
                aaah       = 1'b0;
            end
            FALLING: begin
                aaah = 1'b1;
                // walk signals same as previous walking direction
                if (walk_dir == 0) begin
                    walk_left  = 1'b1;
                    walk_right = 1'b0;
                end else begin
                    walk_left  = 1'b0;
                    walk_right = 1'b1;
                end
            end
            default: begin
                walk_left  = 1'b1;
                walk_right = 1'b0;
                aaah       = 1'b0;
            end
        endcase
    end

endmodule