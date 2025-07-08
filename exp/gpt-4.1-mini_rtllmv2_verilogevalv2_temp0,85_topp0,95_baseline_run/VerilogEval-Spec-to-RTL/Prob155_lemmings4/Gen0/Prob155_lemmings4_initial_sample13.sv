module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);
    // State encoding
    typedef enum logic [3:0] {
        WALK_LEFT    = 4'd0,
        WALK_RIGHT   = 4'd1,
        FALL_LEFT    = 4'd2,
        FALL_RIGHT   = 4'd3,
        DIG_LEFT     = 4'd4,
        DIG_RIGHT    = 4'd5,
        SPLAT        = 4'd6
    } state_t;

    state_t state, next_state;
    reg [4:0] fall_count, next_fall_count; // 5 bits for count up to >20

    // Combinational next state logic and outputs (Moore outputs)
    always @(*) begin
        // Defaults
        next_state = state;
        next_fall_count = fall_count;

        // Default outputs (Moore outputs)
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case(state)
            SPLAT: begin
                // All outputs zero
                // next_state stays SPLAT
                // fall_count irrelevant
            end

            WALK_LEFT: begin
                walk_left = 1'b1;
                if (ground == 1'b0) begin
                    // Fall has highest precedence
                    next_state = FALL_LEFT;
                    next_fall_count = 5'd1; // start counting fall
                end else if (dig == 1'b1) begin
                    // Digging second priority
                    next_state = DIG_LEFT;
                end else begin
                    // Switch direction if bumped
                    if (bump_left || bump_right) begin
                        next_state = WALK_RIGHT;
                    end
                end
            end

            WALK_RIGHT: begin
                walk_right = 1'b1;
                if (ground == 1'b0) begin
                    next_state = FALL_RIGHT;
                    next_fall_count = 5'd1;
                end else if (dig == 1'b1) begin
                    next_state = DIG_RIGHT;
                end else begin
                    if (bump_left || bump_right) begin
                        next_state = WALK_LEFT;
                    end
                end
            end

            FALL_LEFT: begin
                aaah = 1'b1;
                next_fall_count = fall_count + 1'b1;
                if (ground == 1'b1) begin
                    // Check if splatter
                    if (fall_count > 5'd20) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = WALK_LEFT;
                        next_fall_count = 5'd0;
                    end
                end
                // bumped or dig ignored while falling
            end

            FALL_RIGHT: begin
                aaah = 1'b1;
                next_fall_count = fall_count + 1'b1;
                if (ground == 1'b1) begin
                    if (fall_count > 5'd20) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = WALK_RIGHT;
                        next_fall_count = 5'd0;
                    end
                end
            end

            DIG_LEFT: begin
                digging = 1'b1;
                walk_left = 1'b1;
                if (ground == 1'b0) begin
                    // Digging ends, fall left
                    next_state = FALL_LEFT;
                    next_fall_count = 5'd1;
                end
                // bump and dig inputs ignored while digging
            end

            DIG_RIGHT: begin
                digging = 1'b1;
                walk_right = 1'b1;
                if (ground == 1'b0) begin
                    next_state = FALL_RIGHT;
                    next_fall_count = 5'd1;
                end
            end

            default: begin
                // Default safe state to WALK_LEFT
                next_state = WALK_LEFT;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Sequential logic: state and fall_count update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
        end
    end

endmodule