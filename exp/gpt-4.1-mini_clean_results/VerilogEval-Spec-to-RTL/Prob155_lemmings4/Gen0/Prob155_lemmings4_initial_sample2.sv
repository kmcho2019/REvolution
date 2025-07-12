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

    // Define FSM states
    typedef enum logic [2:0] {
        WALK_LEFT = 3'b000,
        WALK_RIGHT = 3'b001,
        FALLING_LEFT = 3'b010,
        FALLING_RIGHT = 3'b011,
        DIGGING_LEFT = 3'b100,
        DIGGING_RIGHT = 3'b101,
        SPLATTERED = 3'b110
    } state_t;

    state_t state, next_state;

    // Fall duration counter (5 bits to count at least to 20)
    reg [4:0] fall_count, next_fall_count;

    // Combinational logic for next_state and next_fall_count
    always @(*) begin
        // Default assignments
        next_state = state;
        next_fall_count = fall_count;

        case(state)
            WALK_LEFT: begin
                // Priority: fall > dig > bump change direction
                if (!ground) begin
                    next_state = FALLING_LEFT;
                    next_fall_count = 5'd1;
                end else if (dig) begin
                    next_state = DIGGING_LEFT;
                end else if (bump_left || bump_right) begin
                    // On bump, switch direction
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING_RIGHT;
                    next_fall_count = 5'd1;
                end else if (dig) begin
                    next_state = DIGGING_RIGHT;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end
            end
            FALLING_LEFT: begin
                if (!ground) begin
                    // Continue falling and increment fall count
                    next_fall_count = fall_count + 1'b1;
                    next_state = FALLING_LEFT;
                end else begin
                    // Hit ground
                    if (fall_count > 5'd20)
                        next_state = SPLATTERED;
                    else
                        next_state = WALK_LEFT;
                    next_fall_count = 5'd0;
                end
            end
            FALLING_RIGHT: begin
                if (!ground) begin
                    next_fall_count = fall_count + 1'b1;
                    next_state = FALLING_RIGHT;
                end else begin
                    if (fall_count > 5'd20)
                        next_state = SPLATTERED;
                    else
                        next_state = WALK_RIGHT;
                    next_fall_count = 5'd0;
                end
            end
            DIGGING_LEFT: begin
                if (!ground) begin
                    // Fall after digging ground disappears
                    next_state = FALLING_LEFT;
                    next_fall_count = 5'd1;
                end else begin
                    // Continue digging
                    next_state = DIGGING_LEFT;
                end
            end
            DIGGING_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING_RIGHT;
                    next_fall_count = 5'd1;
                end else begin
                    next_state = DIGGING_RIGHT;
                end
            end
            SPLATTERED: begin
                // Remain splattered forever until reset
                next_state = SPLATTERED;
                next_fall_count = 5'd0;
            end
            default: begin
                // Default safe state
                next_state = WALK_LEFT;
                next_fall_count = 5'd0;
            end
        endcase
    end

    // Sequential logic: state and fall_count update; async reset on posedge areset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
        end
    end

    // Moore outputs based on current state
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;
        case(state)
            WALK_LEFT: walk_left = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING_LEFT, FALLING_RIGHT: aaah = 1'b1;
            DIGGING_LEFT, DIGGING_RIGHT: digging = 1'b1;
            SPLATTERED: ; // All outputs zero
            default: ; // all outputs zero
        endcase
    end

endmodule