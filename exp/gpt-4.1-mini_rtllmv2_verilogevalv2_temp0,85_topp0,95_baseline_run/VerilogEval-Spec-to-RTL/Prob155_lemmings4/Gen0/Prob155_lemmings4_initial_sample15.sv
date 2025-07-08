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

// State encoding
localparam WALK_LEFT   = 3'd0;
localparam WALK_RIGHT  = 3'd1;
localparam FALLING_LEFT  = 3'd2;
localparam FALLING_RIGHT = 3'd3;
localparam DIGGING_LEFT  = 3'd4;
localparam DIGGING_RIGHT = 3'd5;
localparam SPLATTER      = 3'd6;

reg [2:0] state, next_state;
reg [4:0] fall_count; // 5 bits to count up to >20

// State register and fall counter
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 0;
    end else begin
        state <= next_state;
        if (state == FALLING_LEFT || state == FALLING_RIGHT) begin
            // Increment fall count while falling
            fall_count <= fall_count + 1'b1;
        end else begin
            // Reset fall counter otherwise
            fall_count <= 0;
        end
    end
end

// Next state logic
always @(*) begin
    next_state = state; // default hold

    case (state)
        WALK_LEFT: begin
            // Precedence: fall > dig > bump > stay walking left
            if (!ground) begin
                next_state = FALLING_LEFT;
            end else if (dig) begin
                next_state = DIGGING_LEFT;
            end else if (bump_left || bump_right) begin
                // bump left or bump right or both: switch to walk right
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_LEFT;
            end
        end

        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING_RIGHT;
            end else if (dig) begin
                next_state = DIGGING_RIGHT;
            end else if (bump_left || bump_right) begin
                // switch to walk left
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end

        DIGGING_LEFT: begin
            // continue digging while ground=1
            if (!ground) begin
                // ground lost -> fall
                next_state = FALLING_LEFT;
            end else begin
                // ignore dig input while digging, stay digging
                next_state = DIGGING_LEFT;
            end
        end

        DIGGING_RIGHT: begin
            if (!ground) begin
                next_state = FALLING_RIGHT;
            end else begin
                next_state = DIGGING_RIGHT;
            end
        end

        FALLING_LEFT: begin
            if (ground) begin
                // hit ground after falling
                if (fall_count > 20) begin
                    next_state = SPLATTER;
                end else begin
                    next_state = WALK_LEFT;
                end
            end else begin
                next_state = FALLING_LEFT;
            end
        end

        FALLING_RIGHT: begin
            if (ground) begin
                if (fall_count > 20) begin
                    next_state = SPLATTER;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end else begin
                next_state = FALLING_RIGHT;
            end
        end

        SPLATTER: begin
            // terminal state, no outputs
            next_state = SPLATTER;
        end

        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// Output logic (Moore)
always @(*) begin
    walk_left  = 1'b0;
    walk_right = 1'b0;
    aaah       = 1'b0;
    digging    = 1'b0;

    case(state)
        WALK_LEFT: begin
            walk_left = 1'b1;
        end

        WALK_RIGHT: begin
            walk_right = 1'b1;
        end

        DIGGING_LEFT, DIGGING_RIGHT: begin
            digging = 1'b1;
        end

        FALLING_LEFT, FALLING_RIGHT: begin
            aaah = 1'b1;
        end

        SPLATTER: begin
            // all zero
        end
    endcase
end

endmodule