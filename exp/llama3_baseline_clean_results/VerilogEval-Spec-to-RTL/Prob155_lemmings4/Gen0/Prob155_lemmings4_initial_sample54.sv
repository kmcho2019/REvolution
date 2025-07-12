module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define the states
enum logic [2:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTERED
} state, next_state;

// Define the number of clock cycles that the Lemming has been falling
logic [5:0] fall_count;

// Define the walking direction
logic walk_dir;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        fall_count <= 0;
        walk_dir <= 1'b0; // Walk left
    end else begin
        state <= next_state;
        if (state == FALLING) begin
            fall_count <= fall_count + 1;
        end else begin
            fall_count <= 0;
        end
    end
end

always_comb begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                // Do nothing
            end
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (~ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (bump_left) begin
                // Do nothing
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                if (fall_count > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = walk_dir? WALK_LEFT : WALK_RIGHT;
                end
            end
        end
        DIGGING: begin
            digging = 1'b1;
            if (~ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: begin
            // Do nothing
        end
    endcase

    if (state == WALK_LEFT) begin
        walk_dir = 1'b0;
    end else if (state == WALK_RIGHT) begin
        walk_dir = 1'b1;
    end
end

endmodule