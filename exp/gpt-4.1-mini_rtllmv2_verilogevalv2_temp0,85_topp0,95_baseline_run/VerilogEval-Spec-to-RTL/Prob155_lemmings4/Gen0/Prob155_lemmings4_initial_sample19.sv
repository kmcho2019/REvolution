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
localparam WALK_LEFT     = 3'd0;
localparam WALK_RIGHT    = 3'd1;
localparam FALLING_LEFT  = 3'd2;
localparam FALLING_RIGHT = 3'd3;
localparam DIGGING_LEFT  = 3'd4;
localparam DIGGING_RIGHT = 3'd5;
localparam SPLATTERED    = 3'd6;

reg [2:0] state, next_state;
reg [4:0] fall_count, next_fall_count; // 5 bits to count up to >20

// Asynchronous reset and state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 5'd0;
    end else begin
        state <= next_state;
        fall_count <= next_fall_count;
    end
end

// Next state logic and fall count logic
always @(*) begin
    // Default next values
    next_state = state;
    next_fall_count = fall_count;

    case(state)
        WALK_LEFT: begin
            // Priority: fall > dig > bump
            if (!ground) begin
                // ground lost, start falling left
                next_state = FALLING_LEFT;
                next_fall_count = 5'd1; // start counting from 1 (or 0 is also fine, but 1 to count cycles)
            end else if (dig) begin
                // start digging left
                next_state = DIGGING_LEFT;
                next_fall_count = 5'd0;
            end else if (bump_left || bump_right) begin
                // bump detected, switch direction
                // bump_left or bump_right or both => walk right
                next_state = WALK_RIGHT;
                next_fall_count = 5'd0;
            end else begin
                // remain walking left
                next_state = WALK_LEFT;
                next_fall_count = 5'd0;
            end
        end

        WALK_RIGHT: begin
            if (!ground) begin
                // ground lost, start falling right
                next_state = FALLING_RIGHT;
                next_fall_count = 5'd1;
            end else if (dig) begin
                // start digging right
                next_state = DIGGING_RIGHT;
                next_fall_count = 5'd0;
            end else if (bump_left || bump_right) begin
                // bump detected, switch direction left
                next_state = WALK_LEFT;
                next_fall_count = 5'd0;
            end else begin
                next_state = WALK_RIGHT;
                next_fall_count = 5'd0;
            end
        end

        FALLING_LEFT: begin
            if (ground) begin
                // landed on ground
                if (fall_count > 5'd20) begin
                    // splatter
                    next_state = SPLATTERED;
                    next_fall_count = 5'd0;
                end else begin
                    // resume walking left
                    next_state = WALK_LEFT;
                    next_fall_count = 5'd0;
                end
            end else begin
                // still falling, increment counter
                next_state = FALLING_LEFT;
                if (fall_count == 5'd31) begin
                    // saturate counter at max 31 to avoid overflow
                    next_fall_count = 5'd31;
                end else begin
                    next_fall_count = fall_count + 5'd1;
                end
            end
        end

        FALLING_RIGHT: begin
            if (ground) begin
                if (fall_count > 5'd20) begin
                    next_state = SPLATTERED;
                    next_fall_count = 5'd0;
                end else begin
                    next_state = WALK_RIGHT;
                    next_fall_count = 5'd0;
                end
            end else begin
                next_state = FALLING_RIGHT;
                if (fall_count == 5'd31) begin
                    next_fall_count = 5'd31;
                end else begin
                    next_fall_count = fall_count + 5'd1;
                end
            end
        end

        DIGGING_LEFT: begin
            if (!ground) begin
                // fell off while digging, start falling left
                next_state = FALLING_LEFT;
                next_fall_count = 5'd1;
            end else begin
                // continue digging if ground and dig=1 or ignore dig=0 (per spec, no stop digging early)
                next_state = DIGGING_LEFT;
                next_fall_count = 5'd0;
            end
        end

        DIGGING_RIGHT: begin
            if (!ground) begin
                next_state = FALLING_RIGHT;
                next_fall_count = 5'd1;
            end else begin
                next_state = DIGGING_RIGHT;
                next_fall_count = 5'd0;
            end
        end

        SPLATTERED: begin
            // Forever splattered until reset
            next_state = SPLATTERED;
            next_fall_count = 5'd0;
        end

        default: begin
            next_state = WALK_LEFT;
            next_fall_count = 5'd0;
        end
    endcase
end

// Output logic (Moore)
always @(*) begin
    // Default outputs
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case(state)
        WALK_LEFT: begin
            walk_left = 1'b1;
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
        end
        FALLING_LEFT: begin
            aaah = 1'b1;
        end
        FALLING_RIGHT: begin
            aaah = 1'b1;
        end
        DIGGING_LEFT: begin
            walk_left = 1'b1;
            digging = 1'b1;
        end
        DIGGING_RIGHT: begin
            walk_right = 1'b1;
            digging = 1'b1;
        end
        SPLATTERED: begin
            // all outputs 0
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule