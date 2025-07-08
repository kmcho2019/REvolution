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
localparam WALK_LEFT  = 3'd0;
localparam WALK_RIGHT = 3'd1;
localparam FALL_LEFT  = 3'd2;
localparam FALL_RIGHT = 3'd3;
localparam DIG_LEFT   = 3'd4;
localparam DIG_RIGHT  = 3'd5;
localparam SPLATTER   = 3'd6;

reg [2:0] state, next_state;
reg [4:0] fall_count; // to count falling cycles (enough to count past 20)

// Next state logic (combinational)
always @(*) begin
    next_state = state; // default stay
    case(state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALL_LEFT;
            end else if (dig) begin
                next_state = DIG_LEFT;
            end else if (bump_left || bump_right) begin
                // bumped - switch direction
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_LEFT;
            end
        end

        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALL_RIGHT;
            end else if (dig) begin
                next_state = DIG_RIGHT;
            end else if (bump_left || bump_right) begin
                // bumped - switch direction
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end

        FALL_LEFT: begin
            if (ground) begin
                if (fall_count > 5'd20) begin
                    next_state = SPLATTER;
                end else begin
                    next_state = WALK_LEFT;
                end
            end else begin
                next_state = FALL_LEFT;
            end
        end

        FALL_RIGHT: begin
            if (ground) begin
                if (fall_count > 5'd20) begin
                    next_state = SPLATTER;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end else begin
                next_state = FALL_RIGHT;
            end
        end

        DIG_LEFT: begin
            if (!ground) begin
                next_state = FALL_LEFT;
            end else begin
                next_state = DIG_LEFT;
            end
        end

        DIG_RIGHT: begin
            if (!ground) begin
                next_state = FALL_RIGHT;
            end else begin
                next_state = DIG_RIGHT;
            end
        end

        SPLATTER: begin
            next_state = SPLATTER;
        end

        default: begin
            next_state = WALK_LEFT;
        end
    endcase
end

// State and fall_count update logic (sequential)
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 0;
    end else begin
        state <= next_state;

        // fall_count update
        if (next_state == FALL_LEFT || next_state == FALL_RIGHT) begin
            // increment fall count while falling
            if (state == FALL_LEFT || state == FALL_RIGHT) begin
                fall_count <= fall_count + 1'b1;
            end else begin
                fall_count <= 5'd1; // just started falling
            end
        end else begin
            fall_count <= 0;
        end
    end
end

// Outputs (Moore FSM) combinational from state
always @(*) begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case(state)
        WALK_LEFT:  walk_left  = 1'b1;
        WALK_RIGHT: walk_right = 1'b1;
        FALL_LEFT,
        FALL_RIGHT: aaah       = 1'b1;
        DIG_LEFT,
        DIG_RIGHT:  digging    = 1'b1;
        SPLATTER: begin
            // all zero
        end
    endcase
end

endmodule